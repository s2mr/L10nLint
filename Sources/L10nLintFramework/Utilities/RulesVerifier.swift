public class RulesVerifier {
    public static func verify(configuration: Configuration) throws {
        let enabledRules = configuration.enabledRules ?? []
        let disabledRules = configuration.disabledRules ?? []

        try verifyIsRulesExists(enabledRules: enabledRules, disabledRules: disabledRules)
        try verifyIsRulesAlreadyEnabledOrDisabled(enabledRules: enabledRules, disabledRules: disabledRules)
        try verifyIsRulesContainsEachOther(enabledRules: enabledRules, disabledRules: disabledRules)
    }

    private static func verifyIsRulesExists(enabledRules: [String], disabledRules: [String]) throws {
        let existsIDs = EmbeddedRules.allRules.map { $0.description.identifier }
        for rule in enabledRules {
            if !existsIDs.contains(rule) {
                throw MessageError("Your configuration's enabled rule '\(rule)' is undefined.")
            }
        }

        for rule in disabledRules {
            if !existsIDs.contains(rule) {
                throw MessageError("Your configuration's disabled rule '\(rule)' is undefined.")
            }
        }
    }

    private static func verifyIsRulesAlreadyEnabledOrDisabled(enabledRules: [String], disabledRules: [String]) throws {
        let allRuleIDs = EmbeddedRules.allRules.map { $0.description.identifier }
        let defaultEnabledRulesIDs = EmbeddedRules.defaultEnabledRules.map { $0.description.identifier }
        let defaultDisabledRulesIDs = allRuleIDs.filter { !defaultEnabledRulesIDs.contains($0) }

        for rule in enabledRules {
            if defaultEnabledRulesIDs.contains(rule) {
                throw MessageError("Your configuration's enabled rule '\(rule)' is default enabled.")
            }
        }

        for rule in disabledRules {
            if defaultDisabledRulesIDs.contains(rule) {
                throw MessageError("Your configuration's disabled rule '\(rule)' is default disabled.")
            }
        }
    }

    private static func verifyIsRulesContainsEachOther(enabledRules: [String], disabledRules: [String]) throws {
        for rule in enabledRules {
            if disabledRules.contains(rule) {
                throw MessageError("Your configuration's enabled rule '\(rule)' is defined for disabled rule too.")
            }
        }
    }
}
