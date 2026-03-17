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

        let hasCurrentPathGit = runGit(args: repoValidationArgs)
        var notInitRepos = [String]()
        var notRemoteRepos = [String]()

        let items = try fm.contentsOfDirectory(
            at: path,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles])

        // TASK: if it's already a repo, check if it has a remote

        switch hasCurrentPathGit {
        case true:
            print(repoDetectedMessage)
        case false:
            for item in items {
                let values = try item.resourceValues(forKeys: [.isDirectoryKey])
                let item = item.lastPathComponent

                if values.isDirectory == true {
                    let hasPathGit = runGit(args: [
                        "-C", item, "rev-parse", "--is-inside-work-tree",
                    ])
                    let hasPathGHRemote = runGit(args: ["-C", item, "remote"])

                    if !hasPathGit {
                        notInitRepos += [item]
                        notRemoteRepos += [item]
                    } else if hasPathGit && !hasPathGHRemote {
                        notRemoteRepos += [item]
                    }
                }
            }

            if notInitRepos.count > 0 {
                print(
                    """
                    Swarm overview:

                    The following \(notInitRepos.count == 1 ? "directory" : "directories") will be initialized:
                    \("📁 \(notInitRepos.map { $0 }.joined(separator: "\n📁 "))")

                    The following \(notInitRepos.count == 1 ? "directory" : "directories") will be mirrored to GitHub:
                    \("📁 \(notRemoteRepos.map { $0 }.joined(separator: "\n📁 "))")
                    \(trustPrompt)
                    """, terminator: "")

                if let response = readLine() {
                    if response == "y" {
                        print("Swarm in progress...")

                        for notInitRepo in notInitRepos {
                            initGit(item: notInitRepo)
                        }

                        for notRemoteRepo in notRemoteRepos {
                                addGit(item: notRemoteRepo)
                                commitGit(item: notRemoteRepo)
                                createGitHubRepo(item: notRemoteRepo)
                            }
                    }
                }
                print("Swarm complete.")
            } else {
                print(notReposEmptyMessage)
            }
        }
    }
}