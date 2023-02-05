public class RulesFilter {
    public static func enabledRules(for configuration: Configuration) -> [Rule.Type] {
        let defaultEnabledRulesIDs = EmbeddedRules.defaultEnabledRules.map { $0.description.identifier }
        let enabledIDs = Set(
            defaultEnabledRulesIDs
            - (configuration.disabledRules ?? [])
            + (configuration.enabledRules ?? [])
        )
        return EmbeddedRules.allRules.filter {
            enabledIDs.contains($0.description.identifier)
        }
    }
}

private extension [String] {
    static func - (lhs: [String], rhs: [String]) -> [String] {
        lhs.filter {
            !rhs.contains($0)
        }
    }
}

public class EmbeddedRules {
    public static let allRules: [Rule.Type] = [
        TodoRule.self,
        KeyOrderRule.self,
        DuplicateKeyRule.self,
        MarkSyntaxRule.self,
        EmptyValueRule.self,
        EmptyKeyRule.self,
        MultiLinefeedRule.self,
        SpaceInKeyRule.self
    ]

    public static let defaultEnabledRules: [Rule.Type] = [
        TodoRule.self,
        KeyOrderRule.self,
        DuplicateKeyRule.self,
        MarkSyntaxRule.self,
        EmptyValueRule.self,
        EmptyKeyRule.self,
        MultiLinefeedRule.self,
        SpaceInKeyRule.self
    ]
}
