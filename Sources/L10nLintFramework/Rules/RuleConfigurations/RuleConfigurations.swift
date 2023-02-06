import Yams

public struct RuleConfigurations {
    public var todo: TodoRuleConfiguration?
}

extension RuleConfigurations: Codable {
    enum CodingKeys: CodingKey {
        case todo
    }
}

extension RuleConfigurations: CustomStringConvertible {
    public var description: String {
        (try? YAMLEncoder().encode(self)) ?? "nil"
    }
}
