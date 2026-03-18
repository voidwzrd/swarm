# swarm
macOS Terminal app that concurrently processes batches of commands

⚠️ Under development. Use at your own risk. ⚠️

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
⚠️ Under development. Use at your own risk. ⚠️

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
