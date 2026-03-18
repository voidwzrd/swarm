import Foundation

enum GitAction {
    case add
    case commit
    case initGit
    case remote
    case revParse

    func arguments(atPath path: String? = nil, for item: String) -> [String] {
        switch self {
        case .add:
            return ["-C", item, "add", "."]
        case .commit:
            return ["-C", item, "commit", "-m", "testing repo-ifying of \(item)"]
        case .initGit:
            return ["-C", item, "init"]
        case .remote:
            return ["-C", item, "remote"]
        case .revParse:
            if let path = path {
                return ["-C", path, "rev-parse", "--is-inside-work-tree", "HEAD"]
            } else {
                return ["rev-parse", "--is-inside-work-tree", "HEAD"]
            }
        }
    }
}

struct GitManager {
    private func runCommand(in directory: String, action: GitAction, item: String) -> (
        success: Bool, output: String
    ) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.currentDirectoryURL = URL(fileURLWithPath: directory)
        process.arguments = action.arguments(for: item)

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
            process.waitUntilExit()

            switch action {
            case .add:
                print("\(item): \(gitAddSuccessNotification)")
            case .commit:
                print("\(item): \(gitCommitSuccessNotification)")
            case .initGit:
                print("\(item): \(gitInitSuccessNotification)")
            case .revParse:
                print("\(item): \(gitRevParseSuccessNotification)")
            default:
                print("Action successful")
            }

            return (true, "")
        } catch {
            print(error)
            return (false, "")
        }
    }

    func runGitAdd(item: String) {
        let result = runCommand(in: item, action: .add, item: item)
        print(result.success)
    }

    func runGitCommit(item: String) {
        let result = runCommand(in: item, action: .commit, item: item)
        print(result.success)
    }

    func runGitInit(item: String) {
        let result = runCommand(in: item, action: .initGit, item: item)
        print(result.success)
    }

    func runGitRemote(item: String) -> Bool {
        let result = runCommand(in: item, action: .commit, item: item)
        return result.success
    }

    func runGitRevParse(atPath path: String? = nil, item: String) -> Bool {
        let result = runCommand(in: item, action: .revParse, item: item)
        print(result.output)
        return true
    }
}