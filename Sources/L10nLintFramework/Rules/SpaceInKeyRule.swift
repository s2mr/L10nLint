import Foundation

struct SpaceInKeyRule: Rule {
    static var description: RuleDescription = .init(identifier: "space_in_key", name: "Space in key", description: "")

    init() {}

    func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        let keyRegex = try NSRegularExpression(pattern: #"^"(.*)" = .*";$"#, options: [.anchorsMatchLines])

        let projectContents = project.stringsFile.contents
        return keyRegex.matches(in: projectContents).compactMap { result in
            guard let range = Range(result.range(at: 1), in: projectContents) else { return nil  }
            let key = String(projectContents[range])

            guard key.rangeOfCharacter(from: .whitespaces) != nil else { return nil }

            return StyleViolation(
                ruleDescription: Self.description,
                severity: .warning,
                location: Location(file: project.stringsFile, characterOffset: result.range.location)
            )
        }
    }
}
