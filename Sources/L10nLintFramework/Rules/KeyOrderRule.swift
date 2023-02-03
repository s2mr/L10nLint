import Foundation

struct KeyOrderRule: Rule {
    static var description: RuleDescription = .init(identifier: "key_order", name: "Key order", description: "")

    init() {}

    func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation] {
        guard baseProject.id != project.id else { return [] }

        let keyRegex = try NSRegularExpression(pattern: #"^"(.*)" = .*";$"#, options: [.anchorsMatchLines])

        let baseContents = baseProject.stringsFile.contents
        let baseKeyDataArray: [KeyData] = keyRegex.matches(in: baseContents, range: NSRange(location: 0, length: baseContents.count))
            .compactMap { result in
                guard let range = Range(result.range(at: 1), in: baseContents) else { return nil }
                return KeyData(name: baseProject.name, key: String(baseContents[range]), range: result.range(at: 1))
            }

        let projectContents = project.stringsFile.contents
        let projectKeyDataArray: [KeyData] = keyRegex.matches(in: projectContents, range: NSRange(location: 0, length: projectContents.count))
            .compactMap { result in
                guard let range = Range(result.range(at: 1), in: projectContents) else { return nil }
                return KeyData(name: project.name,key: String(projectContents[range]), range: result.range(at: 1))
            }

        func makeViolation(range: NSRange, severity: ViolationSeverity = .warning, reason: String?) -> StyleViolation {
            StyleViolation(
                ruleDescription: Self.description,
                severity: severity,
                location: Location(file: project.stringsFile, characterOffset: range.location),
                reason: reason
            )
        }
        let changes = projectKeyDataArray.difference(from: baseKeyDataArray, by: { $0.key == $1.key })
            .inferringMoves()

        var violations: [StyleViolation] = []
        for change in changes {
            switch change {
            case let .insert(_, projectKeyData, nil):
                // 定義されていないkeyです
                violations += [
                    StyleViolation(
                        ruleDescription: Self.description,
                        severity: .error,
                        location: Location(file: project.stringsFile, characterOffset: projectKeyData.range.location),
                        reason: "'\(projectKeyData.key)' is not found in Base.lproj"
                    )
                ]

            case let .insert(_, projectKeyData, .some(associatedWith)):
                // Keyの順番が違います。associatedWithに移動してください
                let line = Location(file: baseProject.stringsFile, characterOffset: baseKeyDataArray[associatedWith].range.location).line.map(String.init)
                violations += [
                    StyleViolation(
                        ruleDescription: Self.description,
                        severity: .error,
                        location: Location(file: project.stringsFile, characterOffset: projectKeyData.range.location),
                        reason: "'\(projectKeyData.key)' should be placed at line:\(line ?? "nil")"
                    )
                ]

            case let .remove(_, baseKeyData, nil):
                let baseLine = Location(file: baseProject.stringsFile, characterOffset: baseKeyData.range.location).line
                // Keyが足りません
                violations += [
                    StyleViolation(
                        ruleDescription: Self.description,
                        severity: .error,
                        location: Location(file: project.stringsFile.path, line: baseLine, character: 1),
                        reason: "'\(baseKeyData.key)' is missing."
                    )
                ]

            case let .remove(_, baseKeyData, .some(associatedWith)):
                // Keyの順番が違います。associatedWithにあります。
                let baseLine = Location(file: baseProject.stringsFile, characterOffset: baseKeyData.range.location).line
                let line = Location(file: project.stringsFile, characterOffset: projectKeyDataArray[associatedWith].range.location).line.map(String.init)
                violations += [
                    StyleViolation(
                        ruleDescription: Self.description,
                        severity: .error,
                        location: Location(file: project.stringsFile.path, line: baseLine, character: 1),
                        reason: "'\(baseKeyData.key)' should be placed here. See at line:\(line ?? "nil")"
                    )
                ]
            }
        }

        return violations
    }
}

private struct KeyData: Hashable {
    var name: String
    var key: String
    var range: NSRange

    // for collection difference
    static func == (lhs: KeyData, rhs: KeyData) -> Bool {
        lhs.key == rhs.key
    }

    // for collection difference
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}

private extension CollectionDifference.Change {
    var offset: Int {
        switch self {
        case .remove(let offset, _, _):
            return offset

        case .insert(let offset, _, _):
            return offset
        }
    }
}
