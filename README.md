# homebrew-warden

Homebrew tap for Warden's clients (macOS and Linux).

```sh
brew install magicorntech/warden/warden-cli          # the command-line client (binary: warden), macOS and Linux
brew install --cask magicorntech/warden/warden       # the macOS app (Apple Silicon)
```

Use the full names above: Homebrew only trusts its own taps by default, and installing a fully qualified name trusts just that one item.
(`brew tap magicorntech/warden` and then `brew install warden-cli` works only after `brew trust --formula magicorntech/warden/warden-cli`.)

This repository holds only the formula (`Formula/warden-cli.rb`), the cask (`Casks/warden.rb`) and, as GitHub Releases, the built
binaries they download. Releases are cut automatically from Magicorn's build pipeline on a version tag; do not edit the formula or cask by hand.
