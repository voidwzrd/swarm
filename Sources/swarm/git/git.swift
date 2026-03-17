import Foundation

func addCommitGit(item: String) {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
    process.arguments = ["-C", item, "add", ".", "&&", "git", "commit", "-m", "testing repo-ifying of \(item)"]

    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe

    do {
        try process.run()
        process.waitUntilExit()

        print(gitAddCommitSuccessNotification)
    } catch {
        print(error)
    }
}

func createGitHubRepo(item: String)  {
    let command = "/opt/homebrew/bin/gh"

    let process = Process()
    process.executableURL = URL(fileURLWithPath: command)
    process.currentDirectoryURL = URL(fileURLWithPath: item)
    process.arguments = ["repo", "create", item, "--public", "--source=.", "--remote=origin", "--push"]

    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe

    do {
        try process.run()
        process.waitUntilExit()
    } catch {
        print("ERROR: Failed to run command \(error)")
    }

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    
    print(output)
}

func initGit(item: String) {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
    process.arguments = ["-C", item, "init"]

    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe

    do {
        try process.run()
        process.waitUntilExit()

        print(gitInitSuccessNotification)
    } catch {
        print(error)
    }
}

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