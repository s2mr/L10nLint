import RegexBuilder
import Foundation

public struct TodoRule: Rule {
    public static var description: RuleDescription = .init(identifier: "todo", name: "todo", description: "TODOs and FIXMEs should be resolved.")

    public init() {
    }

    public func validate(baseProject: LocalizedProject, project: LocalizedProject) -> [StyleViolation] {
        let regex = try! NSRegularExpression(pattern: "TODO:", options: [])
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

public struct DuplicateKeyRule: Rule {
    public static var description: RuleDescription = .init(identifier: "", name: "", description: "")

    public init() {
    }

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
