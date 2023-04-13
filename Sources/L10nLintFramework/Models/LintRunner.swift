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

        let violations =  try linters.flatMap {
            try $0.lint()
        }

        return violations
            .filterByPrioritizeTodoOverMixedChinese(for: configuration)
            .modifyByTodoSummary(for: configuration)
    }
}

private extension [StyleViolation] {
    func filterByPrioritizeTodoOverMixedChinese(for configuration: Configuration) -> [StyleViolation] {
        guard configuration.prioritizeTodoOverMixedChinese else { return self }
        let todoViolations = filter { $0.ruleIdentifier == TodoRule.description.identifier }

        let filteredMixedChineseViolations = filter { violation in
            guard violation.ruleIdentifier == MixedChineseRule.description.identifier else { return false }

            return !todoViolations.contains(where: { todoViolation in
                violation.location.file == todoViolation.location.file && violation.location.line == todoViolation.location.line
            })
        }

        let otherViolations = filter {
            $0.ruleIdentifier != MixedChineseRule.description.identifier &&
            $0.ruleIdentifier != TodoRule.description.identifier
        }
        return todoViolations + filteredMixedChineseViolations + otherViolations
    }

    func modifyByTodoSummary(for configuration: Configuration) -> [StyleViolation] {
        let todoConfiguration = configuration.ruleConfigurations.todo ?? .init()
        let todoViolations = filter { $0.ruleIdentifier == TodoRule.description.identifier }
        let otherViolations = filter { $0.ruleIdentifier != TodoRule.description.identifier }

        guard todoConfiguration.isSummaryEnabled && todoViolations.count > todoConfiguration.summaryViolationLimit else { return self }
        var todoViolationsByFile = todoViolations.reduce(into: [String: [StyleViolation]]()) { partialResult, violation in
            if partialResult[violation.location.file ?? ""] == nil {
                partialResult[violation.location.file ?? ""] = []
            }
            partialResult[violation.location.file ?? ""]?.append(violation)
        }

        for violations in todoViolationsByFile {
            let lines = violations.value.compactMap(\.location.line).map(String.init).joined(separator: ",")
            if var violation = violations.value.first {
                violation.location.line = 1
                violation.reason = "Lines has FIXME or TODO. line: \(lines)"
                todoViolationsByFile[violations.key] = [violation]
            }
        }

        return todoViolationsByFile.flatMap(\.value) + otherViolations
    }
}
