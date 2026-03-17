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
        var notRepos = [String]()
        var remotelessRepos = [String]()

        let items = try fm.contentsOfDirectory(
            at: path,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles])

// TASK: if it's already a repo, check if it has a remote


        switch isPathRepo {
        case true:
            print(repoDetectedMessage)
        case false:
            for item in items {
                let values = try item.resourceValues(forKeys: [.isDirectoryKey])
                let item = item.lastPathComponent

                if values.isDirectory == true {
                    let isPathGitRepo = runGit(args: [
                        "-C", item, "rev-parse", "--is-inside-work-tree",
                    ])
                    let isPathGitRemote = runGit(args: ["-C", item, "remote"])

                    if !isPathGitRepo {
                        notRepos += [item]
                    }

                    if !isPathGitRemote {
                        remotelessRepos += [item]
                    }
                }
            }

            if notRepos.count > 0 {
                print(
                    """
                    The following \(notRepos.count == 1 ? "directory" : "directories") will be initialized and mirrored to GitHub:
                    \("📁 \(notRepos.map { $0 }.joined(separator: "\n📁 "))")
                    \(trustPrompt)
                    """, terminator: "")

                if let response = readLine() {
                    if response == "y" {
                        for notRepo in notRepos {
                            print("Swarming \(notRepo)")
                            initGit(item: notRepo)

                            if remotelessRepos.contains(notRepo) {
                                addGit(item: notRepo)
                                commitGit(item: notRepo)
                                createGitHubRepo(item: notRepo)
                            }
                        }
                    }
                }
            } else {
                print(notReposEmptyMessage)
            }
        }
    }
}
