import Foundation

public final class LintRunner {
    public static func run(configuration: Configuration) throws -> [StyleViolation] {
        let projects = try LocalizedProjectFactory.localizedProjects(
            baseDirectory: URL(fileURLWithPath: configuration.basePath)
        )

        return try DispatchQueue.global(qos: .userInteractive).sync {
            try lint(configuration: configuration, projects: projects)
        }
    }

    private static func lint(configuration: Configuration, projects: [LocalizedProject]) throws -> [StyleViolation] {
        guard let baseProject = projects.first(where: { $0.name == "Base" }) else { return [] }

        let rules = RulesFilter.enabledRules(for: configuration).map { rule -> Rule in
            let rule: Rule = rule.init()
            if var rule = rule as? any ConfigurationProviderRule {
                rule.apply(ruleConfigurations: configuration.ruleConfigurations)
                return rule
            }
            return rule
        }
        let linters = projects.map { project in
            return Linter(baseProject: baseProject, project: project, rules: rules)
        }

        return try linters.flatMap {
            try $0.lint()
        }
    }
}
