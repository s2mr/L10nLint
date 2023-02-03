import XCTest
@testable import L10nLintFramework
import class Foundation.Bundle

final class L10nLintFrameworkTests: XCTestCase {
    func testRule() throws {
        let baseProject = try TestHelper.localizedProjects().first(where: { $0.name == "Base" })!
        let violations = TodoRule().validate(baseProject: baseProject, project: baseProject)
        let path = baseProject.stringsFile.path
        XCTAssertEqual(
            violations.map(\.location),
            [
                Location(file: path, line: 1, character: 4),
                Location(file: path, line: 14, character: 4),
                Location(file: path, line: 15, character: 10),
            ]
        )
    }
}
