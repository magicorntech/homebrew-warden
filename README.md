# homebrew-warden

Homebrew tap for Warden's clients (macOS and Linux).

```sh
brew tap magicorntech/warden
brew install warden-cli          # the command-line client (binary: warden), macOS and Linux
brew install --cask warden       # the macOS app (Apple Silicon)
```

This repository holds only the formula (`Formula/warden-cli.rb`), the cask (`Casks/warden.rb`) and, as GitHub Releases, the built
binaries they download. Releases are cut automatically from Magicorn's build pipeline on a version tag; do not edit the formula or cask by hand.
