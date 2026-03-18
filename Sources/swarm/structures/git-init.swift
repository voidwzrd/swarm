import ArgumentParser
import Foundation

struct GitInit: ParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
        abstract:
            "Initializes a Git repository in the current or specified directory. Skips if repo already exists and reports success or failure."
    )

    func run() throws {
        let fileManager = FileManager.default
        let path = URL(fileURLWithPath: fileManager.currentDirectoryPath)

        let isCurrentPathGit = GitManager().runGitRevParse(item: "")

        var reposWithoutInit = [String]()
        var reposWithoutRemote = [String]()

        let items = try fileManager.contentsOfDirectory(
            at: path,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles])

        switch isCurrentPathGit {
        case true:
            print(repoDetectedMessage)
        case false:
            for item in items {
                let values = try item.resourceValues(forKeys: [.isDirectoryKey])
                let item = item.lastPathComponent

                if values.isDirectory == true {
                    let hasPathGit = GitManager().runGitRevParse(item: item)
                    let hasPathGhRemote = GitManager().runGitRemote(item: item)

                    if !hasPathGit {
                        reposWithoutInit += [item]
                        reposWithoutRemote += [item]
                    } else if hasPathGit && !hasPathGhRemote {
                        reposWithoutRemote += [item]
                    }
                }
            }

            if reposWithoutInit.count > 0 || reposWithoutRemote.count > 0 {
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
                            print("GI64")
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
