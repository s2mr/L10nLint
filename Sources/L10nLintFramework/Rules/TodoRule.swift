import Foundation

public struct TodoRule: ConfigurationProviderRule {
    public static let description: RuleDescription = .init(identifier: "todo", name: "Todo", description: "TODOs and FIXMEs should be resolved.")

    public var configuration = TodoRuleConfiguration()

    public init() {}

    public func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        let regex = try NSRegularExpression(pattern: "^.*(TODO|FIXME):.*$", options: [.anchorsMatchLines])

        let projectContents = project.stringsFile.contents
        let dataSets = regex.matches(in: project.stringsFile.contents).compactMap { result -> DataSet? in
            guard let range = Range(result.range(at: 0), in: projectContents) else { return nil }

            return DataSet(
                violation: StyleViolation(
                    ruleDescription: Self.description,
                    severity: .warning,
                    location: Location(file: project.stringsFile, characterOffset: result.range.location)
                ),
                content: String(projectContents[range])
            )
        }

        return dataSets.map(\.violation)
    }
}

private struct DataSet {
    var violation: StyleViolation
    var content: String
}
