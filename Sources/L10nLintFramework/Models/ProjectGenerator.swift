import Foundation

public final class ProjectGenerator {
    enum GenerateError: Error {
        case positionNotFound
    }

    public func generateContent(project: LocalizedProject, markers: [CopyMarker]) throws -> String {
        let targetFile = project.stringsFile

        let mutableTargetContents = NSMutableString(string: targetFile.contents)
        for marker in markers {
            switch marker.previousLineContent {
            case nil:
                mutableTargetContents.insert(
                    marker.content + "\n",
                    at: 0
                )

            case .comment(let line):
                let regex = try NSRegularExpression(pattern: "^\(line)$", options: .anchorsMatchLines)
                let numberOfMatches = regex.replaceMatches(
                    in: mutableTargetContents,
                    range: NSRange(location: 0, length: mutableTargetContents.length),
                    withTemplate: line + "\n" + marker.content
                )
                if numberOfMatches == 0 {
                    throw GenerateError.positionNotFound
                }

            case .data(let key):
                let regex = try NSRegularExpression(pattern: "^\"\(key)\" = .*\";$", options: .anchorsMatchLines)
                let numberOfMatches = regex.replaceMatches(
                    in: mutableTargetContents,
                    range: NSRange(location: 0, length: mutableTargetContents.length),
                    withTemplate: "$0" + "\n" + marker.content
                )
                if numberOfMatches == 0 {
                    throw GenerateError.positionNotFound
                }
            }
        }

        return mutableTargetContents as String
    }

    public func markerRemovedContent(baseProject: LocalizedProject) -> String {
        let mutableString = NSMutableString(string: baseProject.stringsFile.contents)
        CopyMarkerDetector.Const.startMarkerRegex.replaceMatches(in: mutableString, range: NSRange(location: 0, length: mutableString.length), withTemplate: "")
        CopyMarkerDetector.Const.endMarkerRegex.replaceMatches(in: mutableString, range: NSRange(location: 0, length: mutableString.length), withTemplate: "")
        return mutableString as String
    }
}
