import Foundation

public final class XCFileListExporter {
    private let fileRewriter: FileRewriterProtocol

    public init(fileRewriter: FileRewriterProtocol) {
        self.fileRewriter = fileRewriter
    }

    public func exportXCFileList(projects: [LocalizedProject], at path: String) throws {
        let content = try generateContent(projects: projects)
        try fileRewriter.rewrite(at: path, with: content)
    }

    func generateContent(projects: [LocalizedProject]) throws -> String {
        return projects.compactMap { project in
            guard let path = project.stringsFile.path else { return nil }
            return URL(fileURLWithPath: path).path
                .replacingOccurrences(
                    of: FileManager.default.currentDirectoryPath,
                    with: "$(SRCROOT)"
                )
        }
        .sorted()
        .joined(separator: "\n")
    }
}
