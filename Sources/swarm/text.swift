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

let gitInitSuccessNotification = "`git init` successful"
let gitAddSuccessNotification = "`git add` successful"
let gitCommitSuccessNotification = "`git commit` successful"
let gitRevParseSuccessNotification = "`git rev-parse` successful"

let processingMessage = "Processing..."

let loadingMessage = "Swarm in progress..."