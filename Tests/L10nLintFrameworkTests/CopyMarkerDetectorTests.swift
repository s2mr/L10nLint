import XCTest
@testable import L10nLintFramework

final class CopyMarkerDetectorTests: XCTestCase {
    func testDetectMarkers() throws {
        let baseProject = try TestHelper.baseProject(fixtureName: "Localizables4")
        let markers = try CopyMarkerDetector().detectMarkers(file: baseProject.stringsFile)
        XCTAssertEqual(markers.count, 3)
        XCTAssertEqual(markers[0].previousLineContent, nil)
        XCTAssertEqual(markers[0].content, "// Header")
        XCTAssertEqual(markers[0].startLocation.point, .init(line: 1, character: 1))
        XCTAssertEqual(markers[0].endLocation.point, .init(line: 4, character: 1))

        XCTAssertEqual(markers[1].previousLineContent, .data(key: "SecondKey"))
        XCTAssertEqual(markers[1].content, #""SecondGen1" = "Second gen value 1";\#n"SecondGen2" = "Second gen value 2";"#)
        XCTAssertEqual(markers[1].startLocation.point, .init(line: 9, character: 1))
        XCTAssertEqual(markers[1].endLocation.point, .init(line: 13, character: 1))

        XCTAssertEqual(markers[2].previousLineContent, .comment("// MARK: Third"))
        XCTAssertEqual(markers[2].content, #""ThirdGen1" = "Third gen value 1";\#n  "ThirdGen2"   =   "Third gen value 2"  ;"#)
        XCTAssertEqual(markers[2].startLocation.point, .init(line: 15, character: 1))
        XCTAssertEqual(markers[2].endLocation.point, .init())
    }
}
