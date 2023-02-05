import Foundation

struct MessageError: LocalizedError, CustomStringConvertible, Equatable {
    var description: String { message }

    var message: String

    init(_ message: String) {
        self.message = message
    }
}
