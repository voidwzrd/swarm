import ArgumentParser
import Foundation

struct GhDelete: ParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
        abstract: "Delete multiple GitHub repos"
    )

    func run() throws {
        let fm = FileManager.default
        let path = URL(fileURLWithPath: fm.currentDirectoryPath)

        let hasCurrentPathGit = GitManager().runGitRevParse(item: path.lastPathComponent)
        var gitHubRepos = [String]()

        let items = try fm.contentsOfDirectory(
            at: path,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles])

        switch hasCurrentPathGit {
        case true:
            print(repoDetectedMessage)
        case false:
            print(processingMessage)

            for item in items {
                let values = try item.resourceValues(forKeys: [.isDirectoryKey])
                let item = item.lastPathComponent

                if values.isDirectory == true {
                    let isGitHubRepo = GithubManager().viewGithubStatus(item: item)

                    if isGitHubRepo {
                        gitHubRepos += [item]
                    }
                }
            }
        }

        if gitHubRepos.count > 0 {
            print(
                """
                Swarm overview:

                The following GitHub \(gitHubRepos.count == 1 ? "repo" : "repos") will be permanently deleted:
                \("❌ \(gitHubRepos.map { $0 }.joined(separator: "\n❌ "))")

                \(trustPrompt)
                """, terminator: "")
            if let response = readLine() {
                if response == "y" {
                    print(loadingMessage)

                    for gitHubRepo in gitHubRepos {
                        GithubManager().deleteGithubRepo(item: gitHubRepo)
                    }

                    print("Swarm complete.")
                } else {
                    print("Swarm canceled.")
                }
            }
        } else {
            print(notReposEmptyMessage)
        }
    }
}
