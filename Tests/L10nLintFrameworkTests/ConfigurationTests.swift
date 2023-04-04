import XCTest
@testable import L10nLintFramework

final class ConfigurationTests: XCTestCase {
    func testLoad1() throws {
        XCTAssertEqual(
            try Configuration.load(at: TestHelper.fixtureURL(fixtureName: "config1.yml")),
            Configuration(
                basePath: "Tests/L10nLintFrameworkTests/Resources/Fixtures/Localizables4",
                reporter: nil,
                disabledRules: Optional(["empty_value"]),
                enabledRules: nil,
                prioritizeTodoOverMixedChinese: true,
                ruleConfigurations: RuleConfigurations(
                    todo: .init(isSummaryEnabled: true, summaryViolationLimit: 20)
                )
            )
        )
    }
}
