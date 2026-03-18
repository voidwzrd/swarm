import Foundation

enum GithubAction {
    case createRepo
    case deleteRepo
    case viewStatus

    func arguments(for item: String) -> [String] {
        switch self {
        case .createRepo:
            return ["repo", "create", item, "--source=.", "--push", "--public"]
        case .deleteRepo:
            return ["repo", "delete", item, "--yes"]
        case .viewStatus:
            return ["repo", "view", item, "--json", "url"]
        }
    }
}

struct GithubManager {
    private func runCommand(in directory: String, action: GithubAction, item: String) -> (success: Bool, output: String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/gh")
        process.currentDirectoryURL = URL(fileURLWithPath: directory)
        process.arguments = action.arguments(for: item)

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            print("Error: Failed to run command \(error)")
            return (false, "")
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""

        return (process.terminationStatus == 0, output)
    }

    func createGithubRepo(item: String) {
        let result = runCommand(in: item, action: .createRepo, item: item)
        print(result.output)
    }

    func deleteGithubRepo(item: String) {
        let result = runCommand(in: item, action: .deleteRepo, item: item)
        print(result.success)
    }

    func viewGithubStatus(item: String) -> Bool {
        let result = runCommand(in: item, action: .viewStatus, item: item)
        return result.success
    }
}