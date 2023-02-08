import Foundation
import L10nLintFramework

final class TestHelper {
    static func localizedProjects(fixtureName: String) throws -> [LocalizedProject] {
        let currentDirectory = URL(string: #file)!.deletingLastPathComponent()
        let url = URL(string: "\(currentDirectory.path)/Resources/Fixtures/\(fixtureName)")!
        return try LocalizedProjectFactory.localizedProjects(baseDirectory: url)
    }

    static func baseProject(fixtureName: String) throws -> LocalizedProject {
        try localizedProjects(fixtureName: fixtureName)
            .first(where: { $0.name == "Base" })!
    }

    static func project(fixtureName: String, language: String) throws -> LocalizedProject {
        try localizedProjects(fixtureName: fixtureName)
            .first(where: { $0.name == language })!
    }
}
