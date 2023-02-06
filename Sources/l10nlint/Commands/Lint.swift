import ArgumentParser
import Foundation
import L10nLintFramework

// TODO: Check command
// warningがある場合Dangerで表示

// TODO: Correct command
// - Baseを編集したらそれぞれにコピー // markerをつけてその中身をコピー
// - 並び順を自動補正

extension MainTool {
    struct Lint: ParsableCommand {
        @Option
        var config: String?

        func run() throws {
            let configuration = try Configuration.load(customPath: config)
            let violations = try LintRunner.run(configuration: configuration)
            let reporter = reporterFrom(identifier: configuration.reporter ?? XcodeReporter.identifier)
            let reportString = reporter.generateReport(violations)
            if !reportString.isEmpty {
                queuedPrint(reportString)
            }
            if violations.map(\.severity).contains(.error) {
                throw ExitCode.failure
            }
        }
    }
}
