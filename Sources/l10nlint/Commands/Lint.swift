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

            DispatchQueue.global(qos: .userInteractive).sync {
                let violations = lint(projects: projects)
                let reportString = XcodeReporter.generateReport(violations)
                if !reportString.isEmpty {
                    queuedPrint(reportString)
                }
            }
        }

        func lint(projects: [LocalizedProject]) -> [StyleViolation] {
            let rules: [Rule] = [
                TodoRule()
            ]

            guard let baseProject = projects.first(where: { $0.name == "Base" }) else { return [] }

            let linters = projects.map { project in
                Linter(baseProject: baseProject, project: project, rules: rules)
            }

            return linters.flatMap {
                $0.lint()
            }
        }
    }
}
