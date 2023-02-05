import Foundation

struct MessageError: LocalizedError, CustomStringConvertible {
    var description: String { message }

    var message: String

    init(_ message: String) {
        self.message = message
    }
}
