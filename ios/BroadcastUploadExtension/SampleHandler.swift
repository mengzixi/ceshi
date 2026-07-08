import ReplayKit
import Foundation

/// The Broadcast Upload Extension handler that captures screen content via ReplayKit
/// and sends it to the main app through a Unix domain socket in the App Group container.
class SampleHandler: RPBroadcastSampleHandler {

    // MARK: - Constants

    /// Must match the App Group identifier configured in the main app's entitlements
    /// and the RTCAppGroupIdentifier in the main app's Info.plist.
    private enum Constants {
        static let appGroupIdentifier = "group.com.anaranar.meetair"
    }

    // MARK: - Properties

    private var socketConnection: SocketConnection?
    private var hasConnected = false
    private let frameProcessingQueue = DispatchQueue(label: "org.jitsi.meet.BroadcastExtension.FrameProcessing")

    // MARK: - Lifecycle

    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        // Initialize the socket connection to the main app
        guard let connection = SocketConnection(appGroupIdentifier: Constants.appGroupIdentifier) else {
            // Socket path could not be created
            finishBroadcastWithError(NSError(
                domain: "org.jitsi.meet.BroadcastExtension",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Could not create socket connection"]
            ))
            return
        }

        self.socketConnection = connection

        // Retry connecting to the main app's socket (it may not be ready immediately)
        attemptConnection(retryCount: 0)
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with type: RPSampleBufferType) {
        guard type == .video else { return }

        frameProcessingQueue.async { [weak self] in
            self?.handleVideoSampleBuffer(sampleBuffer)
        }
    }

    override func broadcastFinished() {
        socketConnection?.disconnectAsClient()
        socketConnection = nil
        hasConnected = false
    }

    // MARK: - Private Methods

    private func attemptConnection(retryCount: Int) {
        guard retryCount < 30 else {
            // Give up after ~3 seconds of retrying
            finishBroadcastWithError(NSError(
                domain: "org.jitsi.meet.BroadcastExtension",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "Timed out connecting to main app socket"]
            ))
            return
        }

        if socketConnection?.connectAsClient() == true {
            hasConnected = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.attemptConnection(retryCount: retryCount + 1)
            }
        }
    }

    private func handleVideoSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        guard hasConnected else { return }

        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)

        defer {
            CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
        }

        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)

        guard let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer) else { return }

        // Create a simple header with width and height, followed by the raw pixel data.
        // The main app will reconstruct the frames.
        let headerSize = 8 // 4 bytes width + 4 bytes height
        let dataSize = bytesPerRow * height
        var frameData = Data(capacity: headerSize + dataSize)

        // Write header: width (UInt32 big-endian) + height (UInt32 big-endian)
        var w = UInt32(width).bigEndian
        var h = UInt32(height).bigEndian
        frameData.append(Data(bytes: &w, count: MemoryLayout<UInt32>.size))
        frameData.append(Data(bytes: &h, count: MemoryLayout<UInt32>.size))

        // Write pixel data
        frameData.append(Data(bytes: baseAddress, count: dataSize))

        // Send through the socket
        if socketConnection?.sendFrameAsClient(frameData) == false {
            // Connection lost — try to reconnect
            hasConnected = false
            attemptConnection(retryCount: 0)
        }
    }
}
