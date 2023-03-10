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

        if configuration.isSummaryEnabled && dataSets.count > configuration.summaryViolationLimit {
            let lines = dataSets.compactMap(\.violation.location.line).map(String.init).joined(separator: ",")

            return [StyleViolation(
                ruleDescription: Self.description,
                severity: .warning,
                location: Location(file: project.stringsFile.path, line: 1),
                reason: "Lines has FIXME or TODO. line: \(lines)"
            )]
        }
        else {
            return dataSets.map(\.violation)
        }
    }
}

private struct DataSet {
    var violation: StyleViolation
    var content: String
}
