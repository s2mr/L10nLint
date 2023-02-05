import ArgumentParser
import Foundation
import L10nLintFramework

// TODO: Check command
// warningがある場合Dangerで表示

// TODO: Correct command
// - Baseを編集したらそれぞれにコピー
// - 並び順を自動補正

extension MainTool {
    struct Lint: ParsableCommand {
        @Option
        var config: String?

        func run() throws {
            let configuration = try Configuration.load(customPath: config)
            let url = URL(fileURLWithPath: configuration.basePath)
            let projects = try LocalizedProjectFactory.localizedProjects(baseDirectory: url)

            let violations = try DispatchQueue.global(qos: .userInteractive).sync {
                let violations = try lint(configuration: configuration, projects: projects)
                let reportString = XcodeReporter.generateReport(violations)
                if !reportString.isEmpty {
                    queuedPrint(reportString)
                }
                return violations
            }

            if violations.map(\.severity).contains(.error) {
                throw ExitCode.failure
            }
        }

        func lint(configuration: Configuration, projects: [LocalizedProject]) throws -> [StyleViolation] {
            guard let baseProject = projects.first(where: { $0.name == "Base" }) else { return [] }

            let rules = RulesFilter.enabledRules(for: configuration).map { rule in
                rule.init()
            }
            let linters = projects.map { project in
                return Linter(baseProject: baseProject, project: project, rules: rules)
            }

            return try linters.flatMap {
                try $0.lint()
            }
        }
    }
}
