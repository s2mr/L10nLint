import XCTest
@testable import L10nLintFramework

final class RulesVerifierTests: XCTestCase {
    func testTodoRule() throws {
        XCTAssertThrowsError(try RulesVerifier.verify(configuration: Configuration(
            disabledRules: ["hoge"]
        ))) { error in
            AssertMessageError(error, MessageError("Your configuration's disabled rule 'hoge' is undefined."))
        }

        XCTAssertThrowsError(try RulesVerifier.verify(configuration: Configuration(
            enabledRules: ["todo_not_matches"]
        ))) { error in
            AssertMessageError(error, MessageError("Your configuration's enabled rule 'todo_not_matches' is undefined."))
        }

        XCTAssertThrowsError(try RulesVerifier.verify(configuration: Configuration(
            enabledRules: ["todo"]
        ))) { error in
            AssertMessageError(error, MessageError("Your configuration's enabled rule 'todo' is default enabled."))
        }
    }
}

private func AssertMessageError(_ expression1: Error, _ expression2: MessageError, line: UInt = #line) {
    XCTAssertEqual(expression1 as! MessageError, expression2, line: line)
}
