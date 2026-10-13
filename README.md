# homebrew-warden

Homebrew tap for Warden's clients (macOS and Linux).

```sh
brew tap magicorntech/warden
brew trust magicorntech/warden   # Homebrew 7 refuses third-party taps (casks in particular) until you trust them
brew install warden-cli          # the command-line client (binary: warden), macOS and Linux
brew install --cask warden       # the macOS app (Apple Silicon)
```

This repository holds only the formula (`Formula/warden-cli.rb`), the cask (`Casks/warden.rb`) and, as GitHub Releases, the built
binaries they download. Releases are cut automatically from Magicorn's build pipeline on a version tag; do not edit the formula or cask by hand.
