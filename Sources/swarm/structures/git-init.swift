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

        let hasCurrentPathGit = GitManager().runGitRevParse(item: path.lastPathComponent)
        var reposWithoutInit = [String]()
        var reposWithoutRemote = [String]()

        let items = try fm.contentsOfDirectory(
            at: path,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles])

        switch hasCurrentPathGit {
        case true:
            print(repoDetectedMessage)
        case false:
            for item in items {
                let values = try item.resourceValues(forKeys: [.isDirectoryKey])
                let item = item.lastPathComponent

                if values.isDirectory == true {
                    let hasPathGit = GitManager().runGitRevParse(item: item, path: item)
                    let hasPathGhRemote = GitManager().runGitRemote(item: item)

                    if !hasPathGit {
                        reposWithoutInit += [item]
                        reposWithoutRemote += [item]
                    } else if hasPathGit && !hasPathGhRemote {
                        reposWithoutRemote += [item]
                    }
                }
            }

            if reposWithoutInit.count > 0 {
                print(
                    """
                    Swarm overview:

                    The following \(reposWithoutInit.count == 1 ? "directory" : "directories") will be initialized:
                    \("📁 \(reposWithoutInit.map { $0 }.joined(separator: "\n📁 "))")

                    The following \(reposWithoutInit.count == 1 ? "directory" : "directories") will be mirrored to GitHub:
                    \("📁 \(reposWithoutRemote.map { $0 }.joined(separator: "\n📁 "))")
                    \(trustPrompt)
                    """, terminator: "")

                if let response = readLine() {
                    if response == "y" {
                        print(loadingMessage)

                        for notInitRepo in reposWithoutInit {
                            GitManager().runGitInit(item: notInitRepo)
                        }

                        for notRemoteRepo in reposWithoutRemote {
                            GitManager().runGitAdd(item: notRemoteRepo)
                            GitManager().runGitCommit(item: notRemoteRepo)
                            GithubManager().createGithubRepo(item: notRemoteRepo)
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
