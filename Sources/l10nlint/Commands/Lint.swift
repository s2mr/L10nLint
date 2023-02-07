import ArgumentParser
import Foundation
import L10nLintFramework

// TODO: Lint command
// Base, enが同じかどうか

// TODO: Correct command
// - Baseを編集したらそれぞれにコピー // markerをつけてその中身をコピー
// - 並び順を自動補正

extension MainTool {
    struct Lint: ParsableCommand {
        static let configuration: CommandConfiguration = .init(
            abstract: "Lint your Localizable.strings"
        )

        @OptionGroup
        var arguments: DefaultArguments

        @Option(help: "Change report format")
        var reporter: String?

        @Flag(help: "When have lint error, exit with error code")
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
