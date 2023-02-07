/// An interface for reporting violations as strings.
public protocol Reporter: CustomStringConvertible {
    /// The unique identifier for this reporter.
    static var identifier: String { get }

    /// Return a string with the report for the specified violations.
    ///
    /// - parameter violations: The violations to report.
    ///
    /// - returns: The report.
    static func generateReport(_ violations: [StyleViolation]) -> String
}

/// Returns the reporter with the specified identifier. Traps if the specified identifier doesn't correspond to any
/// known reporters.
///
/// - parameter identifier: The identifier corresponding to the reporter.
///
/// - returns: The reporter type.
public func reporterFrom(identifier: String) -> Reporter.Type { // swiftlint:disable:this cyclomatic_complexity
    switch identifier {
    case XcodeReporter.identifier:
        return XcodeReporter.self
    case JsonReporter.identifier:
        return JsonReporter.self
    default:
        queuedFatalError("no reporter with identifier '\(identifier)' available.")
    }
}
