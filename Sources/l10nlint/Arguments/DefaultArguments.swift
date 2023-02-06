import ArgumentParser

struct DefaultArguments: ParsableArguments {
    @Option(help: "Custom config file path")
    var config: String?
}
