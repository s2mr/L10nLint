import Foundation

struct KeyValueFormatSpecifierCountRule: Rule {
    static let description: RuleDescription = .init(identifier: "key_value_format_specifier_count", name: "Key Value Format Specifier Count", description: "Format specifier count should be same between key and value")

    init() {}

    func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        let keyValueRegex = try NSRegularExpression(pattern: #"^ *"(?<key>.*)" *= *"(?<value>.*)" *; *$"#, options: .anchorsMatchLines)
        let formatSpecifierRegex = try NSRegularExpression(pattern: #"%[0-9]*(?<type>([@cCsSp]|(([hlqztj]|ll)?[dDuUxXoO])|(L?[aAeEfFg])))"#)

        return keyValueRegex.matches(in: project.stringsFile.contents).compactMap { result in
            let nsStringContents = project.stringsFile.contents as NSString
            let keyString = nsStringContents.substring(with: result.range(withName: "key"))
            let valueString = nsStringContents.substring(with: result.range(withName: "value"))
            let keyFormatSpecifierCounts: [String: Int] = formatSpecifierRegex.matches(in: keyString)
                .reduce(into: [:]) { result, match in
                    let type = (keyString as NSString).substring(with: match.range(withName: "type"))
                    result[type] = (result[type] ?? 0) + 1
                }
            let valueFormatSpecifierCounts: [String: Int] = formatSpecifierRegex.matches(in: valueString)
                .reduce(into: [:]) { result, match in
                    let type = (valueString as NSString).substring(with: match.range(withName: "type"))
                    result[type] = (result[type] ?? 0) + 1
                }

            if Set(keyFormatSpecifierCounts.keys) != Set(valueFormatSpecifierCounts.keys) {
                return StyleViolation(
                    ruleDescription: Self.description,
                    severity: .warning,
                    location: Location(file: project.stringsFile, characterOffset: result.range.location)
                )
            }

            if let _ = keyFormatSpecifierCounts.first(where: { valueFormatSpecifierCounts[$0.key] != $0.value }) {
                return StyleViolation(
                    ruleDescription: Self.description,
                    severity: .warning,
                    location: Location(file: project.stringsFile, characterOffset: result.range.location)
                )
            }
            
            return nil
        }
    }
}
