import Foundation

public struct JsonReporter: Reporter {
    // MARK: - Reporter Conformance
    public static let identifier = "json"

    public var description: String {
        return "Reports violations with json format"
    }

    public static func generateReport(_ violations: [StyleViolation]) -> String {
        let encodeErrorJson = #" {"error": "Encode failed"} "#
        guard let data = try? JSONEncoder().encode(violations) else { return encodeErrorJson }
        return String(data: data, encoding: .utf8) ?? encodeErrorJson
    }
}
