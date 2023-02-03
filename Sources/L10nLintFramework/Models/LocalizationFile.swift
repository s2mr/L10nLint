import Foundation

public final class LocalizedProject {
    public let name: String
    public let stringsFile: File
    public let id: UUID

    public init?(projectURL: URL) {
        guard let stringsFile = File(path: projectURL.appendingPathComponent("Localizable.strings").path) else { return nil }
        self.name = projectURL.lastPathComponent.replacingOccurrences(of: ".\(projectURL.pathExtension)", with: "")
        self.stringsFile = stringsFile
        self.id = UUID()
    }
}

extension LocalizedProject: CustomStringConvertible {
    public var description: String {
        "LocalizedProject(name: \(name), stringsFile: \(stringsFile.path ?? "nil"), id: \(id.uuidString))"
    }
}

public final class LocalizedProjectFactory {
    public static func localizedProjects(baseDirectory: URL) throws -> [LocalizedProject] {
        try FileManager.default.contentsOfDirectory(at: baseDirectory, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "lproj" }
            .compactMap { LocalizedProject(projectURL: $0) }
    }
}
