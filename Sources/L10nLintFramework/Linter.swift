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

    public func lint() throws -> [StyleViolation] {
        try rules.flatMap { rule in
            try rule.validate(baseProject: baseProject, project: project)
        }
    }
}
