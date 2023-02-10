import ArgumentParser
import Foundation
import L10nLintFramework

extension MainTool {
    struct Copy: ParsableCommand {
        static let configuration: CommandConfiguration = .init(
            abstract: "Copy keys your Base Localizable.strings"
        )

        @OptionGroup
        var arguments: DefaultArguments

        @Flag(
            name: .shortAndLong,
            help: "Whether delete marker in Base Localizable.strings"
        )
        var deleteMarker: Bool = false

        func run() throws {
            let configuration = try Configuration.load(customPath: arguments.config)
            let projects = try LocalizedProjectFactory.localizedProjects(
                baseDirectory: URL(fileURLWithPath: configuration.basePath)
            )
            guard let baseProject = projects.first(where: { $0.name == "Base" }) else { return }

            try CodeCopier()
                .copy(baseProject: baseProject, projects: projects, shouldRemoveMarker: deleteMarker)
        }
    }
}
