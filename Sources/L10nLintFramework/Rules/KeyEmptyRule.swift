import Foundation

struct KeyEmptyRule: Rule {
    static var description: RuleDescription = .init(identifier: "key_empty", name: "", description: "")

    init() {}

    func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        let keyRegex = try NSRegularExpression(pattern: #"^"" = ".*";$"#, options: [.anchorsMatchLines])

        return keyRegex.matches(in: project.stringsFile.contents).map { result in
            StyleViolation(
                ruleDescription: Self.description,
                severity: .warning,
                location: Location(file: project.stringsFile, characterOffset: result.range.location)
            )
        }
    }
}
