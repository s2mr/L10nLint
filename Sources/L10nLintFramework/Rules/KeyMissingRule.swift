import Foundation

struct KeyMissingRule: Rule {
    static let description: RuleDescription = .init(identifier: "keymissing", name: "Missing key", description: "")

    init() {}

    func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        let keyRegex = try NSRegularExpression(pattern: #"^"(.*)" = .*";$"#, options: [.anchorsMatchLines])
        let baseContents = baseProject.stringsFile.contents

        let projectContents = project.stringsFile.contents
        let projectKeys: [String] = keyRegex.matches(in: projectContents, range: NSRange(location: 0, length: projectContents.count))
            .compactMap { result in
                guard let range = Range(result.range(at: 1), in: projectContents) else { return nil }
                return String(projectContents[range])
            }

        return keyRegex.matches(in: baseContents, range: NSRange(location: 0, length: baseContents.count))
            .compactMap { result -> StyleViolation? in
                guard let range = Range(result.range(at: 1), in: baseContents) else { return nil }
                let key = String(baseContents[range])

                guard !projectKeys.contains(key) else { return nil }
                return StyleViolation(
                    ruleDescription: Self.description,
                    severity: .error,
                    location: .init(file: project.stringsFile, characterOffset: result.range.location),
                    reason: "'\(key)' is missing."
                )
            }
    }
}
