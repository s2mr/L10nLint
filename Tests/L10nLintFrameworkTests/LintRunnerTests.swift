import XCTest
@testable import L10nLintFramework

final class LintRunnerTests: XCTestCase {
    func testPreferFixMeThanMixedChineseFalse() throws {
        let violations = try LintRunner.run(configuration: Configuration(
            basePath: TestHelper.fixtureURL(fixtureName: "Localizables7").path,
            prioritizeTodoOverMixedChinese: false
        ))
        XCTAssertEqual(violations.map(\.ruleWithLocationPoint), [
            RuleWithLocationPoint(ruleIdentifier: "todo", file: "zh-Hans.lproj", line: 2, character: 1),
            RuleWithLocationPoint(ruleIdentifier: "mixed_chinese", file: "zh-Hans.lproj", line: 2, character: 19),
            RuleWithLocationPoint(ruleIdentifier: "mixed_chinese", file: "zh-Hans.lproj", line: 3, character: 12),
            RuleWithLocationPoint(ruleIdentifier: "todo", file: "zh-Hant.lproj", line: 2, character: 1)
        ])
    }

    func testPreferFixMeThanMixedChineseTrue() throws {
        let violations = try LintRunner.run(configuration: Configuration(
            basePath: TestHelper.fixtureURL(fixtureName: "Localizables7").path,
            prioritizeTodoOverMixedChinese: true
        ))
        XCTAssertEqual(violations.map(\.ruleWithLocationPoint), [
            RuleWithLocationPoint(ruleIdentifier: "todo", file: "zh-Hans.lproj", line: 2, character: 1),
            RuleWithLocationPoint(ruleIdentifier: "mixed_chinese", file: "zh-Hans.lproj", line: 3, character: 12),
            RuleWithLocationPoint(ruleIdentifier: "todo", file: "zh-Hant.lproj", line: 2, character: 1)
        ])
    }
}

private struct RuleWithLocationPoint: Equatable, CustomStringConvertible {
    var ruleIdentifier: String
    var file: String?
    var line: Int?
    var character: Int?

    var description: String {
        "RuleWithLocationPoint(ruleIdentifier: \"\(ruleIdentifier)\", file: \"\(file ?? "nil")\", line: \(line ?? -1), character: \(character ?? -1))"
    }
}

private extension StyleViolation {
    var ruleWithLocationPoint: RuleWithLocationPoint {
        let components = location.file!.components(separatedBy: "/")
        return RuleWithLocationPoint(
            ruleIdentifier: ruleIdentifier,
            file: components[components.count - 2],
            line: location.line,
            character: location.character
        )
    }
}
