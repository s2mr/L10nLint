import Foundation

/// An executable value that can identify issues (violations) in Swift source code.
public protocol Rule {
    /// A verbose description of many of this rule's properties.
    static var description: RuleDescription { get }

    /// A default initializer for rules. All rules need to be trivially initializable.
    init()

    func validate(baseProject: LocalizedProject, project: LocalizedProject) throws -> [StyleViolation]
}
