import ArgumentParser
import Foundation

@main
struct MainTool: ParsableCommand {
    static let configuration: CommandConfiguration = {
        if let directory = ProcessInfo.processInfo.environment["BUILD_WORKSPACE_DIRECTORY"] {
            FileManager.default.changeCurrentDirectoryPath(directory)
        }

        return CommandConfiguration(
            commandName: "l10nlint",
            subcommands: [
                Lint.self
            ],
            defaultSubcommand: Lint.self
        )
    }()
}
