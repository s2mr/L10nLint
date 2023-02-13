import Foundation

struct KeyValueExtraSpaceRule: Rule {
    static let description: RuleDescription = .init(identifier: "key_value_extra_space", name: "Key value extra space", description: "Key value should be correct spacing.")

    init() {}

    func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        let keyValueMatchesRegex = try NSRegularExpression(pattern: #"^ *".*" *= *".*" *; *$"#, options: .anchorsMatchLines)
        let correctKeyValueRegex = try NSRegularExpression(pattern: #"^".*" = ".*";$"#, options: .anchorsMatchLines)

        let projectContents = project.stringsFile.contents
        return keyValueMatchesRegex.matches(in: projectContents).compactMap { result in
            guard let range = Range(result.range(at: 0), in: projectContents) else { return nil }
            let line = String(projectContents[range])
            guard correctKeyValueRegex.firstMatch(in: line) == nil else { return nil }
            return StyleViolation(
                ruleDescription: Self.description,
                severity: .warning,
                location: Location(file: project.stringsFile, characterOffset: result.range.location)
            )
        }
    }
}
