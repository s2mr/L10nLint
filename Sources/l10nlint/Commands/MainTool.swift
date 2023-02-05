import ArgumentParser
import Foundation
import L10nLintFramework

@main
struct MainTool: ParsableCommand {
    static let configuration: CommandConfiguration = {
        if let directory = ProcessInfo.processInfo.environment["BUILD_WORKSPACE_DIRECTORY"] {
            FileManager.default.changeCurrentDirectoryPath(directory)
        }

        return CommandConfiguration(
            commandName: "l10nlint",
            subcommands: [
                Lint.self,
                Rules.self
            ],
            defaultSubcommand: Lint.self
        )
    }()

    @Option
    var config: String?

    func validate() throws {
        let configuration = try Configuration.load(customPath: config)
        try RulesVerifier.verify(configuration: configuration)
    }
}
