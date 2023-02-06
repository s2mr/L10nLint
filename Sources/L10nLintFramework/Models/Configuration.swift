import Foundation
import Yams

public struct Configuration {
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

    public var basePath: String = ""

    /// The identifier for the `Reporter` to use to report style violations.
    public var reporter: String? = XcodeReporter.identifier

    public var disabledRules: [String]? = []

    public var enabledRules: [String]? = []

    public var ruleConfigurations: RuleConfigurations = .init()
}

extension Configuration: Decodable {
    enum CodingKeys: String, CodingKey {
        case reporter
        case basePath = "base_path"
        case disabledRules = "disabled_rules"
        case enabledRules = "enabled_rules"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reporter = try container.decodeIfPresent(String.self, forKey: .reporter)
        self.basePath = try container.decode(String.self, forKey: .basePath)
        self.disabledRules = try container.decodeIfPresent([String].self, forKey: .disabledRules)
        self.enabledRules = try container.decodeIfPresent([String].self, forKey: .enabledRules)

        self.ruleConfigurations = try RuleConfigurations(from: decoder)
    }
}
