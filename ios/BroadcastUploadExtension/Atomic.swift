import Foundation

@propertyWrapper
struct Atomic<Value> {
    private var value: Value
    private let queue = DispatchQueue(label: "org.jitsi.meet.Atomic", attributes: .concurrent)

    init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    var wrappedValue: Value {
        get { queue.sync { value } }
        set { queue.sync(flags: .barrier) { value = newValue } }
    }

    mutating func mutate(_ mutation: (inout Value) -> Void) {
        queue.sync(flags: .barrier) {
            mutation(&value)
        }
    }
}
