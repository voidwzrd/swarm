import Foundation

func createGitHubRepo(_ cmd: String, args: [String] = [], dir: String) -> String {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: cmd)
    process.currentDirectoryURL = URL(fileURLWithPath: dir)
    process.arguments = args

    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe

    do {
        try process.run()
        process.waitUntilExit()
    } catch {
        return "ERROR: Failed to run command \(error)"
    }

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    print(output)

    return output
}