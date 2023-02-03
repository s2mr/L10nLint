import ArgumentParser
import Foundation
import L10nLintFramework

extension MainTool {
    struct Lint: ParsableCommand {
        @Argument
        var path: String

        func run() throws {
            let url = URL(string: path)!
            let projects = try LocalizedProjectFactory.localizedProjects(baseDirectory: url)

            try DispatchQueue.global(qos: .userInteractive).sync {
                let violations = try lint(projects: projects)
                let reportString = XcodeReporter.generateReport(violations)
                if !reportString.isEmpty {
                    queuedPrint(reportString)
                }

                if violations.map(\.severity).contains(.error) {
                    throw ExitCode.failure
                }
            }
        }

        func lint(projects: [LocalizedProject]) throws -> [StyleViolation] {
            guard let baseProject = projects.first(where: { $0.name == "Base" }) else { return [] }

            let rules = RulesFilter.rules.map { $0.init() }
            let linters = projects.map { project in
                return Linter(baseProject: baseProject, project: project, rules: rules)
            }

            return try linters.flatMap {
                try $0.lint()
            }
        }
    }
}
