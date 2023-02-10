import ArgumentParser
import Foundation
import L10nLintFramework

extension MainTool {
    struct Lint: ParsableCommand {
        static let configuration: CommandConfiguration = .init(
            abstract: "Lint your Localizable.strings"
        )

        @OptionGroup
        var arguments: DefaultArguments

        @Option(
            name: .shortAndLong,
            help: "Change report format"
        )
        var reporter: String?

        @Flag(
            name: .shortAndLong,
            help: "When have lint error, exit with error code"
        )
        var failOnError: Bool = false

        func run() throws {
            let configuration = try Configuration.load(customPath: arguments.config)
            let violations = try LintRunner.run(configuration: configuration)
            let reporter = reporterFrom(identifier: reporter ?? configuration.reporter ?? XcodeReporter.identifier)
            let reportString = reporter.generateReport(violations)
            if !reportString.isEmpty {
                queuedPrint(reportString)
            }
            if failOnError && violations.map(\.severity).contains(.error) {
                throw ExitCode.failure
            }
        }
    }
}
