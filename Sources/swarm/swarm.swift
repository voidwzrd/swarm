import ArgumentParser
import Foundation

@main
struct Swarm: ParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "swarm",
        abstract: "Batch process tasks on the command line",
        version: "0.1.4",
        subcommands: [GitInit.self]
    )

    @Flag(name: .long, help: "\(dryRunDescription)")
    var dryRun = false
    
    func run() {
        print(initPrompt, terminator: "")

        if let response = readLine() {
            if response.lowercased() == "y" {
                print("Continuing...")
                GitInit.main()
            } else {
                print("Process terminated.")
            }
        }        
    }
}