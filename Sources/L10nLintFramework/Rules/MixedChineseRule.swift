import Foundation

struct MixedChineseRule: Rule {
    static let description: RuleDescription = .init(identifier: "mixed_chinese", name: "Mixed Chinese", description: "The mixing of traditional and simplified chinese characters should be resolved.")

    init() {}

    func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        print("project name: \(project.name)")
        switch project.name {
        case "zh-Hans":
            // check include traditional characters in simplified chinese
            let regex = try NSRegularExpression(pattern: #"^".+" = ".*(?<chinese>[\#(traditionalCharacters)]+).*";$"#, options: [.anchorsMatchLines])
            return regex.matches(in: project.stringsFile.contents).map { result in
                StyleViolation(
                    ruleDescription: Self.description,
                    severity: .warning,
                    location: Location(file: project.stringsFile, characterOffset: result.range(withName: "chinese").location)
                )
            }
        case "zh-Hant":
            // check include simplified characters in traditional chinese
            let regex = try NSRegularExpression(pattern: #"^".+" = ".*(?<chinese>[\#(simplifiedCharacters)]+).*";$"#, options: [.anchorsMatchLines])
            return regex.matches(in: project.stringsFile.contents).map { result in
                StyleViolation(
                    ruleDescription: Self.description,
                    severity: .warning,
                    location: Location(file: project.stringsFile, characterOffset: result.range(withName: "chinese").location)
                )
            }
        default:
            return []
        }
    }
}
