# swarm
CLI tool to run multiple processes at once
---
- Date started: 2026-03-16
- Version: 0.1.1

## Download and Install
⚠️ WARNING — SHOULD YOU CHOOSE TO CLONE THIS REPO, voidwzrd IS NOT RESPONSIBLE FOR WHAT HAPPENS. IT IS IN THE EARLY STAGES OF DEVELOPMENT.

1. Clone repo from Github
```
git@github.com:voidwzrd/swarm.git
cd rcount
```

2. Build the executable via Swift Package Manager
```
swift build -c release
```

4. Install Globally
```
sudo mv .build/release/swarm /usr/local/bin/swarm
```

5. Verify installation
```
which rcount
```

## Use
⚠️ WARNING — SHOULD YOU CHOOSE TO USE THIS REPO, voidwzrd IS NOT RESPONSIBLE FOR WHAT HAPPENS. IT IS IN THE EARLY STAGES OF DEVELOPMENT.

Run with `swarm`. Currently, it does only thing: Initializes multiple git repos > creates GitHub remote repos. To skip introduction, run `swarm git-init`.