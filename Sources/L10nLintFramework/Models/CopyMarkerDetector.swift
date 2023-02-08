import Foundation

final class CopyMarkerDetector {
    enum Const {
        static let startMark = "@copy"
        static let endMark = "@end"

        static let markerRegex = try! NSRegularExpression(
            pattern: #"\/\/ \#(Const.startMark)\n(.*?)\n\/\/ \#(Const.endMark)\n"#,
            options: [.anchorsMatchLines, .dotMatchesLineSeparators]
        )

        static let commentRegex = try! NSRegularExpression(pattern: #"^( *\/\/.*)$"#, options: [.anchorsMatchLines])
        static let dataRegex = try! NSRegularExpression(pattern: #"^ *"(.*)" *= *".*" *;"#, options: [.anchorsMatchLines])
    }

    func detectMarkers(file: File) throws -> [CopyMarker] {
        Const.markerRegex.matches(in: file.contents)
            .compactMap { result -> CopyMarker? in
                guard let range = Range(result.range(at: 1), in: file.contents) else { return nil }
                let startLocation = Location(file: file, characterOffset: result.range(at: 0).location)
                guard let startLineIndex = file.lines.firstIndex(where: { $0.index == startLocation.line }) else { return nil }
                let previousLine = file.lines[safe: startLineIndex - 1]
                let previousLineContent = previousLine.flatMap { line -> CopyMarker.LineContent? in
                    if let commentResult = Const.commentRegex.firstMatch(in: line.content) {
                        guard let range = Range(commentResult.range(at: 0), in: line.content) else { return nil }
                        return .comment(String(line.content[range]))
                    }
                    if let dataResult = Const.dataRegex.firstMatch(in: line.content) {
                        guard let range = Range(dataResult.range(at: 1), in: line.content) else { return nil }
                        return .data(key: String(line.content[range]))
                    }
                    return nil
                }
                return CopyMarker(
                    previousLineContent: previousLineContent,
                    content: String(file.contents[range]),
                    startLocation: startLocation,
                    endLocation: Location(file: file, characterOffset: result.range(at: 0).upperBound)
                )
            }
    }
}
