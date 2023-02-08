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
