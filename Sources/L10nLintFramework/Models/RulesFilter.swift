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
