import Foundation

/// Manages a Unix domain socket connection between the Broadcast Upload Extension
/// and the main app through the shared App Group container.
class SocketConnection {

    private let filePath: String
    private var socketHandle: Int32 = -1
    private var acceptHandle: Int32 = -1

    private let queue = DispatchQueue(label: "org.jitsi.meet.SocketConnection")
    private var shouldRun = false

    /// The handler called when a complete video frame buffer is received.
    var onFrameReceived: ((UnsafePointer<UInt8>, Int, UInt64) -> Void)?

    init?(appGroupIdentifier: String) {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupIdentifier
        ) else {
            return nil
        }

        let socketDir = containerURL.appendingPathComponent("rtc_SSFD")
        if !FileManager.default.fileExists(atPath: socketDir.path) {
            try? FileManager.default.createDirectory(at: socketDir, withIntermediateDirectories: true)
        }

        self.filePath = socketDir.appendingPathComponent("rtc_SSFD.sock").path
    }

    deinit {
        disconnectAsServer()
        disconnectAsClient()
    }

    // MARK: - Server (Main App)

    func startAsServer() -> Bool {
        unlink(filePath)

        socketHandle = socket(AF_UNIX, SOCK_STREAM, 0)
        guard socketHandle >= 0 else { return false }

        var addr = sockaddr_un()
        addr.sun_family = sa_family_t(AF_UNIX)
        filePath.withCString { ptr in
            withUnsafeMutablePointer(to: &addr.sun_path) { dst in
                dst.withMemoryRebound(to: Int8.self, capacity: Int(MemoryLayout.size(ofValue: addr.sun_path))) { dstPtr in
                    _ = strcpy(dstPtr, ptr)
                }
            }
        }

        let addrLen = MemoryLayout.size(ofValue: addr)

        guard bind(socketHandle, unsafePointerCast(&addr), socklen_t(addrLen)) >= 0 else {
            close(socketHandle)
            return false
        }

        guard listen(socketHandle, 1) >= 0 else {
            close(socketHandle)
            return false
        }

        shouldRun = true
        queue.async { [weak self] in
            self?.acceptLoop()
        }

        return true
    }

    private func acceptLoop() {
        while shouldRun {
            acceptHandle = accept(socketHandle, nil, nil)
            guard acceptHandle >= 0 else { continue }

            // Read frame length
            var frameLen: UInt64 = 0
            var buffer = [UInt8](repeating: 0, count: MemoryLayout<UInt64>.size)

            while shouldRun {
                let bytesRead = recv(acceptHandle, &buffer, MemoryLayout<UInt64>.size, 0)
                guard bytesRead == MemoryLayout<UInt64>.size else { break }

                frameLen = buffer.withUnsafeBytes { $0.load(as: UInt64.self) }

                // Read the frame data
                var frameBuffer = [UInt8](repeating: 0, count: Int(frameLen))
                var totalRead = 0
                while totalRead < Int(frameLen) {
                    let r = frameBuffer[totalRead...].withUnsafeMutableBytes { ptr in
                        recv(acceptHandle, ptr.baseAddress, Int(frameLen) - totalRead, 0)
                    }
                    guard r > 0 else { break }
                    totalRead += r
                }

                guard totalRead == Int(frameLen) else { break }

                frameBuffer.withUnsafeBytes { ptr in
                    guard let baseAddress = ptr.baseAddress else { return }
                    onFrameReceived?(baseAddress.assumingMemoryBound(to: UInt8.self), Int(frameLen), frameLen)
                }
            }

            close(acceptHandle)
            acceptHandle = -1
        }
    }

    func disconnectAsServer() {
        shouldRun = false
        if acceptHandle >= 0 {
            close(acceptHandle)
            acceptHandle = -1
        }
        if socketHandle >= 0 {
            close(socketHandle)
            socketHandle = -1
        }
    }

    // MARK: - Client (Broadcast Extension)

    func connectAsClient() -> Bool {
        socketHandle = socket(AF_UNIX, SOCK_STREAM, 0)
        guard socketHandle >= 0 else { return false }

        var addr = sockaddr_un()
        addr.sun_family = sa_family_t(AF_UNIX)
        filePath.withCString { ptr in
            withUnsafeMutablePointer(to: &addr.sun_path) { dst in
                dst.withMemoryRebound(to: Int8.self, capacity: Int(MemoryLayout.size(ofValue: addr.sun_path))) { dstPtr in
                    _ = strcpy(dstPtr, ptr)
                }
            }
        }

        let addrLen = MemoryLayout.size(ofValue: addr)

        guard connect(socketHandle, unsafePointerCast(&addr), socklen_t(addrLen)) >= 0 else {
            close(socketHandle)
            return false
        }

        return true
    }

    func sendFrameAsClient(_ data: Data) -> Bool {
        guard socketHandle >= 0 else { return false }

        var length = UInt64(data.count)
        let sentLen = withUnsafeBytes(of: &length) { ptr in
            send(socketHandle, ptr.baseAddress, MemoryLayout.size(ofValue: length), 0)
        }
        guard sentLen == MemoryLayout.size(ofValue: length) else { return false }

        let sent = data.withUnsafeBytes { ptr -> Int in
            send(socketHandle, ptr.baseAddress, data.count, 0)
        }
        return sent == data.count
    }

    func disconnectAsClient() {
        if socketHandle >= 0 {
            close(socketHandle)
            socketHandle = -1
        }
    }
}

/// Helper to cast sockaddr pointers.
private func unsafePointerCast<T>(_ value: UnsafePointer<T>) -> UnsafePointer<sockaddr> {
    return value.withMemoryRebound(to: sockaddr.self, capacity: 1) { $0 }
}
