import Foundation
import Yams

/**

 Rule

 default enabled -> user disabled
 default disabled -> user enabled

 */

public struct Configuration: Codable {
    enum CodingKeys: String, CodingKey {
        case reporter
        case basePath = "base_path"
        case disabledRules = "disabled_rules"
        case enabledRules = "enabled_rules"
    }

    public static func load(customPath path: String?) throws -> Configuration {
        let configPath = path ?? Self.defaultFileName
        let configURL = URL(fileURLWithPath: configPath)
        return try Configuration.load(at: configURL)
    }

    public static func load(at configURL: URL) throws -> Configuration {
        let data = try Data(contentsOf: configURL)
        return try YAMLDecoder().decode(Self.self, from: data)
    }

    /// The default file name to look for user-defined configurations.
    public static let defaultFileName = ".l10nlint.yml"

    /// The identifier for the `Reporter` to use to report style violations.
    public var reporter: String? = XcodeReporter.identifier

    public var basePath: String = ""

    public var disabledRules: [String]? = []

    public var enabledRules: [String]? = []
}
