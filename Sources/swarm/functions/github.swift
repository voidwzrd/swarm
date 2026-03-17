import Foundation

let cmd = "/opt/homebrew/bin/gh"

func getGitHubRepoStatus(item: String) -> Bool {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: cmd)
    process.currentDirectoryURL = URL(fileURLWithPath: item)
    process.arguments = ["repo", "view", item, "--json", "url"]

    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe

    do {
        try process.run()
        process.waitUntilExit()
    } catch {
        print("ERROR: Failed to run command \(error)")
    }
    
    return process.terminationStatus == 0
}

func createGitHubRepo(item: String)  {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: cmd)
    process.currentDirectoryURL = URL(fileURLWithPath: item)
    process.arguments = ["repo", "create", item, "--source=.", "--push", "--public"]

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

func deleteGitHubRepo(item: String) {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: cmd)
    process.arguments = ["repo", "delete", item, "--yes"]

    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe

    do {
        try process.run()
        process.waitUntilExit()

        print("\(item) permanently deleted.")
    } catch {
        print("ERROR: Failed to run command \(error)")
    }

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    
    print(output)
}