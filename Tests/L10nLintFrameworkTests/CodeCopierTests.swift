import XCTest
@testable import L10nLintFramework

final class CodeCopierTests: XCTestCase {
    func testCopy() throws {
        let rewriterMock = FileRewriterMock()
        let copier = CodeCopier(fileRewriter: rewriterMock)
        let baseProject = try TestHelper.baseProject(fixtureName: "Localizables4")
        let projects = try TestHelper.localizedProjects(fixtureName: "Localizables4")
        try copier.copy(baseProject: baseProject, projects: projects, shouldRemoveMarker: false)
        XCTAssertEqual(rewriterMock.contents.description, """
Path: Localizables4/ja.lproj/Localizable.strings
~~~
// Header
// MARK: Main
"MainKey" = "メインのvalue";

// MARK: Second
"SecondKey" = "2つ目のvalue";
"SecondGen1" = "Second gen value 1";
"SecondGen2" = "Second gen value 2";

// MARK: Third
"ThirdGen1" = "Third gen value 1";
  "ThirdGen2"   =   "Third gen value 2"  ;

""")
    }

    func testCopyShouldRemoveMarker() throws {
        let rewriterMock = FileRewriterMock()
        let copier = CodeCopier(fileRewriter: rewriterMock)
        let baseProject = try TestHelper.baseProject(fixtureName: "Localizables4")
        let projects = try TestHelper.localizedProjects(fixtureName: "Localizables4")
        try copier.copy(baseProject: baseProject, projects: projects, shouldRemoveMarker: true)
        XCTAssertEqual(rewriterMock.contents.description, """
Path: Localizables4/Base.lproj/Localizable.strings
~~~
// Header
// MARK: Main
"MainKey" = "Main value";

// MARK: Second
"SecondKey" = "Second value";
"SecondGen1" = "Second gen value 1";
"SecondGen2" = "Second gen value 2";

// MARK: Third
"ThirdGen1" = "Third gen value 1";
  "ThirdGen2"   =   "Third gen value 2"  ;

~~~
Path: Localizables4/ja.lproj/Localizable.strings
~~~
// Header
// MARK: Main
"MainKey" = "メインのvalue";

// MARK: Second
"SecondKey" = "2つ目のvalue";
"SecondGen1" = "Second gen value 1";
"SecondGen2" = "Second gen value 2";

// MARK: Third
"ThirdGen1" = "Third gen value 1";
  "ThirdGen2"   =   "Third gen value 2"  ;

""")
    }
}
