import ArgumentParser
import Foundation

struct GitInit: ParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
        abstract:
            "Initializes a Git repository in the current or specified directory. Skips if repo already exists and reports success or failure."
    )

    @Flag(name: .long, help: "\(dryRunDescription)")
    var dryRun = false

    func run() throws {
        let fm = FileManager.default
        let path = URL(fileURLWithPath: fm.currentDirectoryPath)
        let isPathRepo = runGit(args: repoValidationArgs)

        let items = try fm.contentsOfDirectory(
            at: path,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles])

        switch isPathRepo {
        case true:
            print(repoDetectedMessage)
        case false:
            for item in items {
                let values = try item.resourceValues(forKeys: [.isDirectoryKey])
                let item = item.lastPathComponent

                if values.isDirectory == true {
                    let isPathGitRepo = runGit(args: ["-C", item, "rev-parse", "--is-inside-work-tree"])

                    if !isPathGitRepo {
                        initGit(item: item)
                        addCommitGit(item: item)
                        createGitHubRepo(item: item)
                    }
                }
            }
        }
    }
}