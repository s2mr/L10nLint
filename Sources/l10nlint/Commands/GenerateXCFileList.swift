import ArgumentParser
import Foundation
import L10nLintFramework

extension MainTool {
    struct GenerateXCFileList: ParsableCommand {
        static let configuration: CommandConfiguration = .init(
            commandName: "generate-xcfilelist",
            abstract: "Generate xcfilelist"
        )

        @OptionGroup
        var arguments: DefaultArguments

        @Option(
            name: .shortAndLong,
            help: "Path to write the xcfilelist for the input files",
            completion: .file(extensions: ["xcfilelist"])
          )
        var inputFilePath: String

        func run() throws {
            let configuration = try Configuration.load(customPath: arguments.config)
            let exporter = XCFileListExporter(fileRewriter: FileRewriter())
            let projects = try LocalizedProjectFactory.localizedProjects(baseDirectory: URL(
                fileURLWithPath: configuration.basePath
            ))
            try exporter.exportXCFileList(projects: projects, at: inputFilePath)
            queuedPrint("'\(inputFilePath)' is generated.")
        }
    }
}
