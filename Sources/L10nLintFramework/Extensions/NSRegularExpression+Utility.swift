import Foundation

extension NSRegularExpression {
    func matches(in string: String) -> [NSTextCheckingResult] {
        self.matches(in: string, range: NSRange(location: 0, length: string.utf16.count))
    }

    func firstMatch(in string: String) -> NSTextCheckingResult? {
        self.firstMatch(in: string, range: NSRange(location: 0, length: string.utf16.count))
    }
}
