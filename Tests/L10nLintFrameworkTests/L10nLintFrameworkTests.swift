import XCTest
@testable import L10nLintFramework
import class Foundation.Bundle

final class L10nLintFrameworkTests: XCTestCase {
    func testTodoRule() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables1")
            .first(where: { $0.name == "Base" })!
        let violations = try TodoRule().validate(baseProject: baseProject, project: baseProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [
                LocationPoint(line: 1, character: 4),
                LocationPoint(line: 14, character: 4),
                LocationPoint(line: 15, character: 10),
                LocationPoint(line: 16, character: 4),
            ]
        )
    }

    func testKeyMissingRule() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables2")
            .first(where: { $0.name == "Base" })!
        let jaProject = try TestHelper.localizedProjects(fixtureName: "Localizables2")
            .first(where: { $0.name == "ja" })!
        let violations = try KeyMissingRule().validate(baseProject: baseProject, project: jaProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [LocationPoint(line: 2, character: 1)]
        )
    }
}

extension Location {
    var point: LocationPoint {
        LocationPoint(line: line, character: character)
    }
}

struct LocationPoint: Equatable, CustomStringConvertible {
    var line: Int?
    var character: Int?

    var description: String {
        "LocationPoint(line: \(line ?? -1), character: \(character ?? -1))"
    }
}
