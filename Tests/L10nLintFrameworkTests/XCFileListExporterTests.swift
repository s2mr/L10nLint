import XCTest
@testable import L10nLintFramework

final class XCFileListExporterTests: XCTestCase {
    func testGenerateContent() throws {
        let projects = try TestHelper.localizedProjects(fixtureName: "Localizables2")
        let content = try XCFileListExporter(
            fileRewriter: FileRewriterMock()
        ).generateContent(projects: projects)
        XCTAssertEqual(content, """
$(SRCROOT)/Tests/L10nLintFrameworkTests/Resources/Fixtures/Localizables2/Base.lproj/Localizable.strings
$(SRCROOT)/Tests/L10nLintFrameworkTests/Resources/Fixtures/Localizables2/en.lproj/Localizable.strings
$(SRCROOT)/Tests/L10nLintFrameworkTests/Resources/Fixtures/Localizables2/ja.lproj/Localizable.strings
""")
    }
}
