public protocol ConfigurationProviderRule: Rule {
    /// The type of configuration used to configure this rule.
    associatedtype ConfigurationType: RuleConfigurationProtocol

    /// This rule's configuration.
    var configuration: ConfigurationType { get set }
}

extension ConfigurationProviderRule {
    public mutating func apply(ruleConfigurations: RuleConfigurations) {
        configuration.apply(ruleConfigurations: ruleConfigurations)
    }
}
