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

        @Flag
        var printParameters: Bool = false

        func run() throws {
            let configuration = try Configuration.load(customPath: config)

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
