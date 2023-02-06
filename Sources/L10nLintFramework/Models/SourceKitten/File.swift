import Dispatch
import Foundation

// swiftlint:disable file_length type_body_length
// This file could easily be split up

/// Represents a source file.
public final class File {
    /// File path. Nil if initialized directly with `File(contents:)`.
    public let path: String?
    /// File contents.
    public var contents: String {
        get {
            _contentsQueue.sync {
                if _contents == nil {
                    _contents = try! String(contentsOfFile: path!, encoding: .utf8)
                }
            }
            return _contents!
        }
        set {
            _contentsQueue.sync {
                _contents = newValue
                _stringViewQueue.sync {
                    _stringView = nil
                }
            }
        }
    }

    public func clearCaches() {
        _contentsQueue.sync {
            _contents = nil
            _stringViewQueue.sync {
                _stringView = nil
            }
        }
    }

    public var stringView: StringView {
        _stringViewQueue.sync {
            if _stringView == nil {
                _stringView = StringView(contents)
            }
        }
        return _stringView!
    }

    public var lines: [Line] {
        return stringView.lines
    }

    private var _contents: String?
    private var _stringView: StringView?
    private let _contentsQueue = DispatchQueue(label: "com.sourcekitten.sourcekitten.file.contents")
    private let _stringViewQueue = DispatchQueue(label: "com.sourcekitten.sourcekitten.file.stringView")

    /**
     Failable initializer by path. Fails if file contents could not be read as a UTF8 string.

     - parameter path: File path.
     */
    public init?(path: String) {
        self.path = path
        do {
            _contents = try String(contentsOfFile: path, encoding: .utf8)
        } catch {
            fputs("Could not read contents of `\(path)`\n", stderr)
            return nil
        }
    }

    public init(pathDeferringReading path: String) {
        self.path = path
    }

    /**
     Initializer by file contents. File path is nil.

     - parameter contents: File contents.
     */
    public init(contents: String) {
        path = nil
        _contents = contents
    }
}
