public struct TodoRuleConfiguration: Equatable, Codable, RuleConfigurationProtocol {
    public enum DefaultValue {
        public static let isSummaryEnabled: Bool = false
        public static let summaryViolationLimit: Int = 10
    }

    enum CodingKeys: String, CodingKey {
        case isSummaryEnabled = "is_summary_enabled"
        case summaryViolationLimit = "summary_violation_limit"
    }

    public var isSummaryEnabled: Bool
    public var summaryViolationLimit: Int

    public init(
        isSummaryEnabled: Bool = DefaultValue.isSummaryEnabled,
        summaryViolationLimit: Int = DefaultValue.summaryViolationLimit
    ) {
        self.isSummaryEnabled = isSummaryEnabled
        self.summaryViolationLimit = summaryViolationLimit
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isSummaryEnabled = try container.decodeIfPresent(Bool.self, forKey: .isSummaryEnabled) ?? DefaultValue.isSummaryEnabled
        self.summaryViolationLimit = try container.decodeIfPresent(Int.self, forKey: .summaryViolationLimit) ?? DefaultValue.summaryViolationLimit
    }

    public mutating func apply(ruleConfigurations: RuleConfigurations) {
        if let todo = ruleConfigurations.todo {
            self = todo
        }
    }
}
