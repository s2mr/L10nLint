import Foundation

public final class CodeCopier {
    private let copyMarkDetector = CopyMarkerDetector()
    private let projectGenerator = ProjectGenerator()
    private let fileRewriter: FileRewriterProtocol

    public init(
        fileRewriter: FileRewriterProtocol = FileRewriter()
    ) {
        self.fileRewriter = fileRewriter
    }

    public func copy(baseProject: LocalizedProject, projects: [LocalizedProject], shouldRemoveMarker: Bool) throws {
        let markers = try copyMarkDetector.detectMarkers(file: baseProject.stringsFile)
        let projectsWithoutBase = projects.filter { $0.name != baseProject.name }

        for project in projectsWithoutBase {
            let content = try projectGenerator.generateContent(project: project, markers: markers)
            guard let path = project.stringsFile.path else { continue }
            try fileRewriter.rewrite(at: path, with: content)
        }

        if shouldRemoveMarker {
            let baseContent = projectGenerator.markerRemovedContent(baseProject: baseProject)
            guard let baseStringPath = baseProject.stringsFile.path else { return }
            try fileRewriter.rewrite(at: baseStringPath, with: baseContent)
        }
    }
}
