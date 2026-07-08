import Foundation

/// A lightweight wrapper around Darwin notifications (CFNotificationCenter)
/// for inter-process communication between the main app and the Broadcast Upload Extension.
enum DarwinNotificationCenter {

    /// Post a Darwin notification by name.
    static func postNotification(_ name: CFString) {
        CFNotificationCenterPostNotification(
            CFNotificationCenterGetDarwinNotifyCenter(),
            CFNotificationName(name),
            nil,
            nil,
            true
        )
    }

    /// Observe a Darwin notification by name. The handler is called on a background queue.
    static func addObserver(
        forName name: CFString,
        using block: @escaping (CFString) -> Void
    ) -> Any {
        let observer = DarwinNotificationObserver(name: name, block: block)
        observer.start()
        return observer
    }
}

private class DarwinNotificationObserver {
    private let name: CFString
    private let block: (CFString) -> Void

    init(name: CFString, block: @escaping (CFString) -> Void) {
        self.name = name
        self.block = block
    }

    func start() {
        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            Unmanaged.passRetained(self).toOpaque(),
            { (_, observer, name, _, _) in
                guard let observer = observer else { return }
                let mySelf = Unmanaged<DarwinNotificationObserver>.fromOpaque(observer).takeUnretainedValue()
                mySelf.block(name.rawValue)
            },
            name,
            nil,
            .deliverImmediately
        )
    }

    deinit {
        CFNotificationCenterRemoveEveryObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            Unmanaged.passRetained(self).toOpaque()
        )
    }
}
