import Foundation

struct MultiLinefeedRule: Rule {
    static let description: RuleDescription = .init(identifier: "multi_linefeed", name: "Multi linefeed", description: "Linefeed should be one.")

    init() {}

    func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        let keyRegex = try NSRegularExpression(pattern: #"^\n{2,}"#, options: [.anchorsMatchLines])

        return keyRegex.matches(in: project.stringsFile.contents).map { result in
            StyleViolation(
                ruleDescription: Self.description,
                severity: .warning,
                location: Location(file: project.stringsFile, characterOffset: result.range.location)
            )
        }
    }
}
