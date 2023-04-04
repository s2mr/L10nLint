import Foundation
import L10nLintFramework

final class TestHelper {
    static func fixtureURL(fixtureName: String) -> URL {
        let currentDirectory = URL(string: #file)!.deletingLastPathComponent()
        return URL(string: "file://\(currentDirectory.path)/Resources/Fixtures/\(fixtureName)")!
    }

    static func localizedProjects(fixtureName: String) throws -> [LocalizedProject] {
        return try LocalizedProjectFactory.localizedProjects(
            baseDirectory: fixtureURL(fixtureName: fixtureName)
        )
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
