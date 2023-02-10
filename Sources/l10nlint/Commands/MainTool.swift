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
            abstract: "Lint tool for your Localizable.strings",
            version: Version.current,
            subcommands: [
                Lint.self,
                Rules.self,
                Copy.self,
                GenerateXCFileList.self
            ],
            defaultSubcommand: Lint.self
        )
    }()

    @OptionGroup
    var arguments: DefaultArguments

    func validate() throws {
        let configuration = try Configuration.load(customPath: arguments.config)
        try RulesVerifier.verify(configuration: configuration)
    }
}
