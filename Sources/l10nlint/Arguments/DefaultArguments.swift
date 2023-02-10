import ArgumentParser

struct DefaultArguments: ParsableArguments {
    @Option(
        name: .shortAndLong,
        help: "Custom config file path"
    )
    var config: String?
}
