public class RulesFilter {
    public static let rules: [Rule.Type] = [
        TodoRule.self,
        KeyOrderRule.self,
        DuplicateKeyRule.self,
        MarkSyntaxRule.self,
        ValueEmptyRule.self,
        KeyEmptyRule.self,
        MultiLinefeedRule.self,
        SpaceInKeyRule.self
    ]
}
