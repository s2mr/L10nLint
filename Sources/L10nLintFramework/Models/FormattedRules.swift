public class FormattedRules {
    public static func allRulesIsEnabled(configuration: Configuration) -> String {
        let ruleDescriptions = EmbeddedRules.allRules.map { $0.description }

        let maxIdentifiersCount = ruleDescriptions.map(\.identifier).max(by: { $0.count < $1.count })?.count ?? 0
        let isEnabledCount = [Keyword.disabled, Keyword.enabled].max(by: { $0.count < $1.count })?.count ?? 0

        let enabledRuleIDs = RulesFilter.enabledRules(for: configuration).map { $0.description.identifier }
        let result = ruleDescriptions
            .sorted(by: { $0.identifier < $1.identifier })
            .map { (description: RuleDescription) in
                let isEnabled = enabledRuleIDs.contains(description.identifier) ? Keyword.enabled : Keyword.disabled

                return [
                    description.identifier.rightPadding(toLength: maxIdentifiersCount + 4, withPad: " "),
                    isEnabled.rightPadding(toLength: isEnabledCount + 4, withPad: " "),
                    description.description
                ].joined()
            }
        return result.joined(separator: "\n")
    }
}

private extension String {
    func rightPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return self + String(repeatElement(character, count: toLength - stringLength))
        } else {
            return self
        }
    }
}

private enum Keyword {
    static let disabled = "disabled"
    static let enabled = "enabled"
}
