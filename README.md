# swarm
A macOS CLI tool to quickly manage multiple GitHub repositories from the terminal.

⚠️⚠️⚠️ WARNING — CLONING, INSTALLING, AND USING `swarm` SHOULD BE DONE WITH EXTREME CAUTION. IT IS IN THE EARLY STAGES OF DEVELOPMENT. voidwzrd IS NOT RESPONSIBLE FOR WHAT HAPPENS. ⚠️⚠️⚠️

## Table of Contents
- [About](#about)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)

---

## About
Built with Swift 5 and ArgumentParser. Project initiated on 2026-03-16 and is currently at version 0.1.5.

---

## Features
- Initialize multiple repositories with a single command
- Supports dry-run and verbose modes
- Automatically ignores nested repositories
- macOS

---

## Installation
⚠️⚠️⚠️ WARNING — CLONING, INSTALLING, AND USING `swarm` SHOULD BE DONE WITH EXTREME CAUTION. IT IS IN THE EARLY STAGES OF DEVELOPMENT. voidwzrd IS NOT RESPONSIBLE FOR WHAT HAPPENS. ⚠️⚠️⚠️

```bash
git clone git@github.com:voidwzrd/swarm.git
cd swarm
swift build -c release
```

To install globally, run
```
sudo mv .build/release/swarm /usr/local/bin/swarm
```

To verify installation, run `which swarm`.

## Usage

Run with `swarm`. Currently, it does only thing: Initializes multiple git repos > creates GitHub remote repos. To skip introduction, run `swarm git-init`.
