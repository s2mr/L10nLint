import Foundation

public final class LocalizedProjectFactory {
    public static func localizedProjects(baseDirectory: URL) throws -> [LocalizedProject] {
        try FileManager.default.contentsOfDirectory(at: baseDirectory, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "lproj" }
            .compactMap { LocalizedProject(projectURL: $0) }
    }
}
