let initPrompt =
    """
    At present, `swarm` permits only a single choice.
    Do you wish to proceed with initializing multiple GitHub repositories using `swarm git-init`? (y/n):
    """

let trustPrompt = "Do you trust us to swarm? (y/n) "

// DESCRIPTIONS
let dryRunDescription = "Run simulation of swarm commands."


let repoDetectedMessage = "Already inside a git repo. Skipping swarm."
let notReposEmptyMessage = "All directories contain git repos. Skipping swarm."

// ARGUMENT HELPERS
let repoValidationArgs = ["rev-parse", "--is-inside-work-tree"]

let gitInitSuccessNotification = "`git init` successful"
let gitAddSuccessNotification = "`git add` successful"
let gitCommitSuccessNotification = "`git commit` successful"

let processingMessage = "Processing..."