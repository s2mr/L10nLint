public struct CopyMarker: Equatable, CustomStringConvertible {
    enum LineContent: Equatable, CustomStringConvertible {
        case comment(String)
        case data(key: String)

        var description: String {
            switch self {
            case .comment(let value):
                return ".comment(\"\(value)\")"
            case .data(let key):
                return ".data(key: \"\(key)\")"
            }
        }
    }

    var previousLineContent: LineContent?
    var content: String
    var startLocation: Location
    var endLocation: Location

    public var description: String {
        return """
GenerateMarker(
    previousLineContent: \(previousLineContent?.description ?? "nil"),
    content: \(content),
    startLocation: \(startLocation),
    endLocation: \(endLocation),
)
"""
    }
}
