import RegexBuilder
import Foundation

public class RulesFilter {
    public static let rules: [Rule.Type] = [
        TodoRule.self,
        KeyMissingRule.self,
        LineOrderRule.self,
        DuplicateKeyRule.self,
        SyntaxRule.self,
        ValueEmptyRule.self,
        MultiLinefeedRule.self,
        SpaceInKeyRule.self,
        BaseL10nMismatchedRule.self
    ]
}

public struct TodoRule: Rule {
    public static var description: RuleDescription = .init(identifier: "todo", name: "Todo", description: "TODOs and FIXMEs should be resolved.")

    public init() {}

    public func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        let regex = try NSRegularExpression(pattern: "(TODO|FIXME):", options: [.anchorsMatchLines])

        let contents = project.stringsFile.contents
        let matches = regex.matches(in: contents, range: NSMakeRange(0, contents.count))

        return matches.map { match in
            StyleViolation(
                ruleDescription: Self.description,
                severity: .warning,
                location: Location(file: project.stringsFile, characterOffset: match.range.location)
            )
        }
    }
}

struct LineOrderRule: Rule {
    static var description: RuleDescription = .init(identifier: "", name: "", description: "")

    init() {
    }

    func validate(baseProject: LocalizedProject, project: LocalizedProject) -> [StyleViolation] {
        []
    }
}

public struct DuplicateKeyRule: Rule {
    public static var description: RuleDescription = .init(identifier: "duplicate_key", name: "Duplicate key", description: "")

    public init() {}

    public func validate(baseProject: LocalizedProject, project: LocalizedProject) -> [StyleViolation] {
        []
    }
}

struct SyntaxRule: Rule {
    static var description: RuleDescription = .init(identifier: "", name: "", description: "")

    init() {
    }

    func validate(baseProject: LocalizedProject, project: LocalizedProject) -> [StyleViolation] {
        []
    }
}

struct ValueEmptyRule: Rule {
    static var description: RuleDescription = .init(identifier: "", name: "", description: "")

    init() {
    }

    func validate(baseProject: LocalizedProject, project: LocalizedProject) -> [StyleViolation] {
        []
    }
}

struct MultiLinefeedRule: Rule {
    static var description: RuleDescription = .init(identifier: "", name: "", description: "")

    init() {
    }

    func validate(baseProject: LocalizedProject, project: LocalizedProject) -> [StyleViolation] {
        []
    }
}

struct SpaceInKeyRule: Rule {
    static var description: RuleDescription = .init(identifier: "", name: "", description: "")

    init() {
    }

    func validate(baseProject: LocalizedProject, project: LocalizedProject) -> [StyleViolation] {
        []
    }
}

struct BaseL10nMismatchedRule: Rule {
    static var description: RuleDescription = .init(identifier: "", name: "", description: "")

    init() {
    }

    func validate(baseProject: LocalizedProject, project: LocalizedProject) -> [StyleViolation] {
        []
    }
}
