import Foundation

struct MarkSyntaxRule: Rule {
    static let description: RuleDescription = .init(identifier: "mark_syntax", name: "Mark syntax", description: "Annotation should have around one space.")

    init() {}

    func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        let annotationRegex = try NSRegularExpression(pattern: #"^\/\/\s*(MARK|TODO|FIXME)\s*:.*$"#, options: .anchorsMatchLines)
        let correctAnnotationRegex = try NSRegularExpression(pattern: #"^\/\/ (MARK|FIXME|TODO): \S.*$"#, options: .anchorsMatchLines)

        let projectContents = project.stringsFile.contents
        return annotationRegex.matches(in: projectContents).compactMap { result in
            guard let range = Range(result.range(at: 0), in: projectContents) else { return nil }
            let line = String(projectContents[range])
            guard correctAnnotationRegex.firstMatch(in: line) == nil else { return nil }
            return StyleViolation(
                ruleDescription: Self.description,
                severity: .warning,
                location: Location(file: project.stringsFile, characterOffset: result.range.location)
            )
        }
    }
}
