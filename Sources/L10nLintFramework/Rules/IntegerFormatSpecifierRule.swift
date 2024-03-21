import Foundation

struct IntegerFormatSpecifierRule: Rule {
    static let description: RuleDescription = .init(identifier: "integer_format_specifier", name: "Integer Format Specifier", description: "Integer format specifier should be '%lld' instead of '%d'")

    init() {}

    func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        let regex = try NSRegularExpression(pattern: #"^.*(?<specifier>%[0-9]*d).*$"#, options: .anchorsMatchLines)

        return regex.matches(in: project.stringsFile.contents).map { result in
            StyleViolation(
                ruleDescription: Self.description,
                severity: .warning,
                location: Location(file: project.stringsFile, characterOffset: result.range(withName: "specifier").location)
            )
        }
    }
}

