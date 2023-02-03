import Foundation
import L10nLintFramework

final class TestHelper {
    static func localizedProjects() throws -> [LocalizedProject] {
        let currentDirectory = URL(string: #file)!.deletingLastPathComponent()
        let url = URL(string: "\(currentDirectory.path)/Resources/Fixtures/Localizables1")!
        return try LocalizedProjectFactory.localizedProjects(baseDirectory: url)
    }
}
