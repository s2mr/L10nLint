/// A detailed description for a SwiftLint rule. Used for both documentation and testing purposes.
public struct RuleDescription: Equatable {
    /// The rule's unique identifier, to be used in configuration files and SwiftLint commands.
    /// Should be short and only comprised of lowercase latin alphabet letters and underscores formatted in snake case.
    public let identifier: String

    /// The rule's human-readable name. Should be short, descriptive and formatted in Title Case. May contain spaces.
    public let name: String

    /// The rule's verbose description. Should read as a sentence or short paragraph. Good things to include are an
    /// explanation of the rule's purpose and rationale.
    public let description: String

    /// Creates a `RuleDescription` by specifying all its properties directly.
    ///
    /// - parameter identifier:            Sets the description's `identifier` property.
    /// - parameter name:                  Sets the description's `name` property.
    /// - parameter description:           Sets the description's `description` property.
    public init(identifier: String, name: String, description: String) {
        self.identifier = identifier
        self.name = name
        self.description = description
    }

    // MARK: Equatable

    public static func == (lhs: RuleDescription, rhs: RuleDescription) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
