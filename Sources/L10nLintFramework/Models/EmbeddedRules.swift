public class EmbeddedRules {
    public static let allRules: [Rule.Type] = [
        TodoRule.self,
        KeyOrderRule.self,
        DuplicateKeyRule.self,
        MarkSyntaxRule.self,
        EmptyValueRule.self,
        EmptyKeyRule.self,
        MultiLinefeedRule.self,
        SpaceInKeyRule.self
    ]

    public static let defaultEnabledRules: [Rule.Type] = [
        TodoRule.self,
        KeyOrderRule.self,
        DuplicateKeyRule.self,
        MarkSyntaxRule.self,
        EmptyValueRule.self,
        EmptyKeyRule.self,
        MultiLinefeedRule.self,
        SpaceInKeyRule.self
    ]
}
