import XCTest
@testable import L10nLintFramework

final class RulesTests: XCTestCase {
    func testTodoRule() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables1")
            .first(where: { $0.name == "Base" })!
        let violations = try TodoRule().validate(baseProject: baseProject, project: baseProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [
                LocationPoint(line: 8, character: 1),
                LocationPoint(line: 9, character: 1),
                LocationPoint(line: 10, character: 1),
                LocationPoint(line: 12, character: 1),
                LocationPoint(line: 14, character: 1)
            ]
        )
    }

    func testDuplicateKeyRule() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables1")
            .first(where: { $0.name == "Base" })!
        let violations = try DuplicateKeyRule().validate(baseProject: baseProject, project: baseProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [LocationPoint(line: 4, character: 2)]
        )
    }

    func testKeyOrderRule() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables2")
            .first(where: { $0.name == "Base" })!
        let jaProject = try TestHelper.localizedProjects(fixtureName: "Localizables2")
            .first(where: { $0.name == "ja" })!
        let violations = try KeyOrderRule().validate(baseProject: baseProject, project: jaProject)
        // TODO: check description
        XCTAssertEqual(
            violations.map(\.location.point),
            [
                LocationPoint(line: 2, character: 1),
                LocationPoint(line: 2, character: 2),
                LocationPoint(line: 6, character: 2)
            ]
        )
    }

    func testMultiLinefeedRule() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables1")
            .first(where: { $0.name == "Base" })!
        let violations = try MultiLinefeedRule().validate(baseProject: baseProject, project: baseProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [LocationPoint(line: 6, character: 1), LocationPoint(line: 15, character: 1)]
        )
    }

    func testEmptyKeyRule() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables1")
            .first(where: { $0.name == "Base" })!
        let violations = try EmptyKeyRule().validate(baseProject: baseProject, project: baseProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [LocationPoint(line: 18, character: 1)]
        )
    }

    func testEmptyValueRule() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables1")
            .first(where: { $0.name == "Base" })!
        let violations = try EmptyValueRule().validate(baseProject: baseProject, project: baseProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [LocationPoint(line: 19, character: 1)]
        )
    }

    func testSpaceInKeyRule() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables1")
            .first(where: { $0.name == "Base" })!
        let violations = try SpaceInKeyRule().validate(baseProject: baseProject, project: baseProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [
                LocationPoint(line: 22, character: 1),
                LocationPoint(line: 23, character: 1),
                LocationPoint(line: 24, character: 1),
                LocationPoint(line: 25, character: 1),
                LocationPoint(line: 26, character: 1),
                LocationPoint(line: 27, character: 1),
                LocationPoint(line: 28, character: 1)
            ]
        )
    }

    func testMarkSyntaxRule() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables3")
            .first(where: { $0.name == "Base" })!
        let violations = try MarkSyntaxRule().validate(baseProject: baseProject, project: baseProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [
                LocationPoint(line: 3, character: 1),
                LocationPoint(line: 4, character: 1),
                LocationPoint(line: 5, character: 1),
                LocationPoint(line: 6, character: 1),
                LocationPoint(line: 8, character: 1),
                LocationPoint(line: 9, character: 1),
                LocationPoint(line: 10, character: 1),
                LocationPoint(line: 11, character: 1),
                LocationPoint(line: 13, character: 1),
                LocationPoint(line: 14, character: 1),
                LocationPoint(line: 15, character: 1),
                LocationPoint(line: 16, character: 1),
                LocationPoint(line: 17, character: 1),
                LocationPoint(line: 18, character: 1)
            ]
        )
    }

    func testKeyValueExtraSpaceRule() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables5")
            .first(where: { $0.name == "Base" })!
        let violations = try KeyValueExtraSpaceRule().validate(baseProject: baseProject, project: baseProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [
                LocationPoint(line: 3, character: 1),
                LocationPoint(line: 4, character: 1),
                LocationPoint(line: 5, character: 1),
                LocationPoint(line: 6, character: 1)
            ]
        )
    }

    func testMixedChineseRuleZhHant() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables6")
            .first(where: { $0.name == "Base" })!
        let zhHantProject = try TestHelper.localizedProjects(fixtureName: "Localizables6")
            .first(where: { $0.name == "zh-Hant" })!

        let violations = try MixedChineseRule().validate(baseProject: baseProject, project: zhHantProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [
                LocationPoint(line: 3, character: 11),
                LocationPoint(line: 5, character: 8),
                LocationPoint(line: 6, character: 8)
            ]
        )
    }

    func testMixedChineseRuleZhHans() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables6")
            .first(where: { $0.name == "Base" })!
        let zhHansProject = try TestHelper.localizedProjects(fixtureName: "Localizables6")
            .first(where: { $0.name == "zh-Hans" })!

        let violations = try MixedChineseRule().validate(baseProject: baseProject, project: zhHansProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [
                LocationPoint(line: 4, character: 11),
                LocationPoint(line: 7, character: 8),
                LocationPoint(line: 8, character: 8)
            ]
        )
    }

    func testIntegerFormatSpecifierRule() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables9")
            .first(where: { $0.name == "Base" })!

        let violations = try IntegerFormatSpecifierRule().validate(baseProject: baseProject, project: baseProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [
                LocationPoint(line: 2, character: 20),
                LocationPoint(line: 3, character: 22),
                LocationPoint(line: 4, character: 7)
            ]
        )
    }

    func testKeyValueFormatSpecifierCountRule() throws {
        let baseProject = try TestHelper.localizedProjects(fixtureName: "Localizables9")
            .first(where: { $0.name == "Base" })!

        let violations = try KeyValueFormatSpecifierCountRule().validate(baseProject: baseProject, project: baseProject)
        XCTAssertEqual(
            violations.map(\.location.point),
            [
                LocationPoint(line: 3, character: 1),
                LocationPoint(line: 4, character: 1),
                LocationPoint(line: 8, character: 1),
                LocationPoint(line: 9, character: 1),
                LocationPoint(line: 10, character: 1)
            ]
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
