import ArgumentParser
import Foundation

@main
struct Swarm: ParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "swarm",
        abstract: "Batch process tasks on the command line",
        version: "0.1.1",
        subcommands: [GitInit.self]
    )

    @Flag(name: .long, help: "In progress: --dry-run to avoid accidental changes")
    var dryRun = false
    
    func run() {
        let welcomeMessage =
        """
        At present, `swarm` permits only a single choice.
        Do you wish to proceed with initializing multiple GitHub repositories? (y/n):
        """

        print(welcomeMessage, terminator: "")

        if let response = readLine() {
            if response.lowercased() == "y" {
                print("Continuing...")
                GitInit.main()
            } else {
                print("Canceled.")
            }
        }        
    }
}