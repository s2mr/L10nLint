import Foundation

public final class Linter {
    public let baseProject: LocalizedProject
    public let project: LocalizedProject
    public let rules: [Rule]

    public init(baseProject: LocalizedProject, project: LocalizedProject, rules: [Rule]) {
        self.baseProject = baseProject
        self.project = project
        self.rules = rules
    }

    public func lint() -> [StyleViolation] {
        rules.flatMap { rule in
            rule.validate(baseProject: baseProject, project: project)
        }
    }
}
