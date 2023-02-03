import Foundation
import L10nLintFramework

final class TestHelper {
    static func localizedProjects(fixtureName: String) throws -> [LocalizedProject] {
        let currentDirectory = URL(string: #file)!.deletingLastPathComponent()
        let url = URL(string: "\(currentDirectory.path)/Resources/Fixtures/\(fixtureName)")!
        return try LocalizedProjectFactory.localizedProjects(baseDirectory: url)
    }
}
