import Foundation

public struct DuplicateKeyRule: Rule {
    public static var description: RuleDescription = .init(identifier: "duplicate_key", name: "Duplicate key", description: "")

    public init() {}

    public func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        let keyRegex = try NSRegularExpression(pattern: #"^"(.*)" = .*";$"#, options: [.anchorsMatchLines])

        let projectContents = project.stringsFile.contents

        var keys: [String] = []
        var violations: [StyleViolation] = []
        for result in keyRegex.matches(in: projectContents, range: NSRange(location: 0, length: projectContents.count)) {
            guard let range = Range(result.range(at: 1), in: projectContents) else { continue }

            let key = String(projectContents[range])
            if !keys.contains(key) {
                keys += [key]
            }
            else {
                violations += [StyleViolation(
                    ruleDescription: Self.description,
                    severity: .error,
                    location: .init(file: project.stringsFile, characterOffset: result.range(at: 1).location),
                    reason: "'\(key)' is duplicated."
                )]
            }
        }
        return violations
    }
}
