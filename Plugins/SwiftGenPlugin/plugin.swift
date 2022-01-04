import PackagePlugin

@main struct SwiftGenPlugin: BuildToolPlugin {
    /// This plugin's implementation returns a single `prebuild` command to run `swiftgen`.
    func createBuildCommands(context: TargetBuildContext) throws -> [Command] {
        // This example configures `swiftgen` to take inputs from a `swiftgen.yml` file
        let swiftGenConfigFile = context.packageDirectory.appending("swiftgen.yml")
        
        // This example configures the command to write to a "GeneratedSources" directory.
        let genSourcesDir = context.pluginWorkDirectory.appending("GeneratedSources")

        // Return a command to run `swiftgen` as a prebuild command. It will be run before
        // every build and generates source files into an output directory provided by the
        // build context. This example sets some environment variables that `swiftgen.yml`
        // bases its output paths on.
        return [.prebuildCommand(
            displayName: "Running SwiftGen",
            executable: try context.tool(named: "swiftgen").path,
            arguments: [
                "config", "run",
                "--config", "\(swiftGenConfigFile)"
            ],
            environment: [
                "PROJECT_DIR": "\(context.packageDirectory)",
                "TARGET_NAME": "\(context.targetName)",
                "DERIVED_SOURCES_DIR": "\(genSourcesDir)",
            ],
            outputFilesDirectory: genSourcesDir)]
    }
}