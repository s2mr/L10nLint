import Foundation

struct EmptyValueRule: Rule {
    static let description: RuleDescription = .init(identifier: "empty_value", name: "Empty value", description: "Empty localized value should be resolved.")

    init() {}

    func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        let keyRegex = try NSRegularExpression(pattern: #"^".+" = "";$"#, options: [.anchorsMatchLines])
        return keyRegex.matches(in: project.stringsFile.contents).map { result in
            StyleViolation(
                ruleDescription: Self.description,
                severity: .warning,
                location: Location(file: project.stringsFile, characterOffset: result.range.location)
            )
        }
    }
}
