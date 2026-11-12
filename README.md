# homebrew-warden

Homebrew tap and Scoop bucket for the Warden desktop app (macOS and Windows). The app carries the `warden` command-line tool:
there is no separate command-line package.

macOS (Apple Silicon and Intel):

```sh
brew install --cask magicorntech/warden/warden       # the app, and the warden command on your PATH
```

Windows (PowerShell):

```powershell
scoop bucket add magicorn https://github.com/magicorntech/homebrew-warden
scoop install warden
```

No package manager? Each release has a macOS disk image for Apple Silicon and Intel (drag Warden to Applications; the app then
offers to put the `warden` command on your PATH) and a Windows installer (`.msi`):
https://github.com/magicorntech/homebrew-warden/releases/latest

On a phone: [App Store](https://apps.apple.com/app/id6832613000) and
[Google Play](https://play.google.com/store/apps/details?id=net.magicorn.warden).

Use the full cask name above: Homebrew only trusts its own taps by default, and installing a fully qualified name trusts just
that one item.

`warden-cli`, the old command-line formula, is discontinued and cannot be installed: `brew uninstall warden-cli`, then install the
cask. The two small `warden-<version>-darwin-*.tar.gz` files on a release are notices for apps older than 0.10.0, which look for
a file of that name before they offer an update; they hold no program.

This repository holds the cask (`Casks/warden.rb`), the Scoop manifest (`bucket/warden.json`), the winget manifests and, as GitHub
Releases, the built app they download. Releases are cut automatically from Magicorn's build pipeline on a version tag; do not edit
the cask or the manifests by hand.
