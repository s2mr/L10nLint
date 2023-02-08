import Foundation

public protocol FileRewriterProtocol: AnyObject {
    func rewrite(at path: String, with string: String) throws
}

public final class FileRewriter: FileRewriterProtocol {
    public init() {}

    public func rewrite(at path: String, with string: String) throws {
        guard let data = string.data(using: .utf8) else { return }
        try data.write(to: URL(fileURLWithPath: path))
    }
}

public final class FileRewriterMock: FileRewriterProtocol {
    public struct Contents: CustomStringConvertible {
        public var values: [String: String] = [:]

        public var description: String {
            return values
                .sorted(by: { $0.key < $1.key })
                .map { value in
                """
                Path: \(value.key.components(separatedBy: "/").suffix(3).joined(separator: "/"))
                ~~~
                \(value.value)
                """
                }.joined(separator: "\n~~~\n")
        }
    }

    public var contents: Contents = Contents()

    public init() {}

    public func rewrite(at path: String, with string: String) throws {
        contents.values[path] = string
    }
}
