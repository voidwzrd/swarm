import ArgumentParser
import Foundation

func runGit(args: [String]) -> Bool {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
    process.arguments = args

    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe

    do {
        try process.run()
        process.waitUntilExit()
    } catch {
        return false
    }

    return process.terminationStatus == 0
}

struct GitInit: ParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(abstract: "Git swarming")

    @Flag(name: .long, help: "In progress: --dry-run to avoid accidental changes")
    var dryRun = false

    func run() throws {
        let fm = FileManager.default
        let path = URL(fileURLWithPath: fm.currentDirectoryPath)
        let isPathRepo = runGit(args: ["rev-parse", "--is-inside-work-tree"])
        var directories = [String]()

        let items = try fm.contentsOfDirectory(
            at: path,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles])

        switch isPathRepo {
        case true:
            print("You are currently inside of a git repo. No swarms will be attempted.")
        case false:
            for item in items {
                let values = try item.resourceValues(forKeys: [.isDirectoryKey])

                if values.isDirectory == true {

                    if runGit(args: ["-C", "\(item.lastPathComponent)", "rev-parse", "--is-inside-work-tree"]) == false {
                        let isGitInit = runGit(args: ["-C", "\(item.lastPathComponent)", "gitrepo", "init"])
                        
                        print(isGitInit ? "git init successful" : "ERROR: (Star Wars sucks)")

                        print(createGitHubRepo("/opt/homebrew/bin/gh", args: ["repo", "create", "my-repo", "--public", "--source=.", "--remote=origin","--push"], dir: "\(item.lastPathComponent)" ))
                        directories += [item.lastPathComponent]
                    } else {
                        print("something wrong git52")
                    }
                }
            }
        }

        switch dryRun {
        case true:
            print("Would print: Git")
        case false:
            print("")
        }
    }
}
