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
        static let configuration: CommandConfiguration = .init(
            abstract: "Show all rules whether enabled or disabled"
        )

        @OptionGroup
        var arguments: DefaultArguments

        @Flag(help: "Show your rule's parameters in config")
        var printParameters: Bool = false

        func run() throws {
            let configuration = try Configuration.load(customPath: arguments.config)

            if printParameters {
                queuedPrint(configuration.ruleConfigurations)
                throw ExitCode.success
            }
            else {
                queuedPrint(FormattedRules.allRulesIsEnabled(configuration: configuration))
            }
        }
    }
}
