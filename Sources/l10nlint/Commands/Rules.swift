import ArgumentParser
import Foundation
import L10nLintFramework

// TODO: Check command
// warningがある場合Dangerで表示

// TODO: Correct command
// - Baseを編集したらそれぞれにコピー
// - 並び順を自動補正

extension MainTool {
    struct Rules: ParsableCommand {
        @Option
        var config: String?

        func run() throws {
            let configPath = config ?? Configuration.defaultFileName
            let configURL = URL(fileURLWithPath: configPath)
            let configuration = try Configuration.load(at: configURL)

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

            queuedPrint(result.joined(separator: "\n"))
        }
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
