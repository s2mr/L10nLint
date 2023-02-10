import ArgumentParser
import Foundation
import L10nLintFramework

extension MainTool {
    struct Rules: ParsableCommand {
        static let configuration: CommandConfiguration = .init(
            abstract: "Show all rules whether enabled or disabled"
        )

        @OptionGroup
        var arguments: DefaultArguments

        @Flag(
            name: .shortAndLong,
            help: "Show your rule's parameters in config"
        )
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
