import XCTest
@testable import L10nLintFramework

final class ProjectGeneratorTests: XCTestCase {
    func testMarkerRemovedContent() throws {
        let baseProject = try TestHelper.baseProject(fixtureName: "Localizables4")
        XCTAssertEqual(baseProject.stringsFile.contents, """
// @copy
// Header
// @end
// MARK: Main
"MainKey" = "Main value";

// MARK: Second
"SecondKey" = "Second value";
// @copy
"SecondGen1" = "Second gen value 1";
"SecondGen2" = "Second gen value 2";
// @end

// MARK: Third
// @copy
"ThirdGen1" = "Third gen value 1";
  "ThirdGen2"   =   "Third gen value 2"  ;
// @end

""")
        let markerRemovedContent = ProjectGenerator().markerRemovedContent(baseProject: baseProject)
        XCTAssertEqual(markerRemovedContent, """
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

""")
    }

    func testGenerateContent() throws {
        let baseProject = try TestHelper.baseProject(fixtureName: "Localizables4")
        let jaProject = try TestHelper.project(fixtureName: "Localizables4", language: "ja")
        let markers = try CopyMarkerDetector().detectMarkers(file: baseProject.stringsFile)
        let content = try ProjectGenerator().generateContent(project: jaProject, markers: markers)
        XCTAssertEqual(content, """
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
