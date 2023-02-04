import Foundation

public struct TodoRule: Rule {
    public static var description: RuleDescription = .init(identifier: "todo", name: "Todo", description: "TODOs and FIXMEs should be resolved.")

    public init() {}

    public func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        let regex = try NSRegularExpression(pattern: "(TODO|FIXME):", options: [.anchorsMatchLines])

        return regex.matches(in: project.stringsFile.contents).map { match in
            StyleViolation(
                ruleDescription: Self.description,
                severity: .warning,
                location: Location(file: project.stringsFile, characterOffset: match.range.location)
            )
        }
    }
}
