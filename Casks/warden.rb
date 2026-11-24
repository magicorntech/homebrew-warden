cask "warden" do
  arch arm: "arm64", intel: "x86_64"

  version "0.10.5"
  sha256 arm:   "d802454417992659b848400964372f4976754f46ae293ba94f3e37eb52d032aa",
         intel: "03d7b194602e1e3072fdb09e3d93684b459de46f82333316af014a558078d89d"

  url "https://github.com/magicorntech/homebrew-warden/releases/download/v#{version}/Warden-#{version}-#{arch}.zip"
  name "Warden"
  desc "Menu-bar client for Warden: keeps your sign-in fresh and pairs this Mac's Secure Enclave"
  homepage "https://github.com/magicorntech/homebrew-warden"

  depends_on macos: :sonoma

  # The steps blocks below are Homebrew's declarative install steps (the Ruby flight blocks are deprecated). They run in Homebrew's
  # sandbox: HOME is a scratch directory there (so a path in the user's home names base: :home, never "~/"), and nothing is written
  # outside what a step declares.
  #
  # The warden command IS the app's daemon binary: one file, one version, and the only executable on a Mac that can reach the Secure
  # Enclave. There is no separate command-line package any more (the formula warden-cli is disabled). Homebrew skips the binary link when
  # a formula's link is in the way, which would leave the retired command on the PATH, so that link is removed first: only when it is a
  # symbolic link into Cellar/warden-cli/, anything else at that path is left alone.
  preflight_steps do
    remove "bin/warden", base: :homebrew_prefix, symlink_target_contains: "Cellar/warden-cli/"
  end

  # Installed as Warden.app, the same name the disk image uses, so an app installed either way is the same app in the same place.
  app "WardenApp.app", target: "Warden.app"
  binary "#{appdir}/Warden.app/Contents/Library/WardenDaemon.app/Contents/MacOS/warden"

  # The daemon is the app's own (WardenDaemon.app inside the bundle: only that executable can reach the Secure Enclave), registered as a
  # LaunchAgent so it runs at every login whether or not the app is open. Installing it is 'warden daemon install', run as the user.
  #
  # The ONE Ruby block left, and deprecated: it cannot be a postflight_steps 'run', because launchd refuses 'launchctl bootstrap' from a
  # sandboxed process (error 5, Input/output error, under any sandbox profile, even one that allows everything; measured 2026-11-13,
  # Homebrew 7.0.13), and a steps 'run' always runs in Homebrew's sandbox. Without it the daemon would be off after every install and
  # upgrade until the app is opened. See docs/CLIENT-RELEASE.md, "The cask's install steps".
  postflight do
    system_command "#{appdir}/Warden.app/Contents/Library/WardenDaemon.app/Contents/MacOS/warden",
                   args: ["daemon", "install"]
  end

  # Removing OR UPGRADING the app removes everything of the running app: the daemon service is unloaded first, then the app is quit (a
  # menu-bar app keeps running after its files go; TERM too if it ignores the quit, also on an upgrade), then the agent file is deleted (an
  # upgrade registers the new one in its postflight), and on a removal the app's own settings and caches are deleted. NOT touched: ~/.warden,
  # the user's logins, device pairing and logs, which are the user's and survive a reinstall.
  #
  # Done with steps, not with the 'launchctl:' and 'delete:' directives, for one reason: Homebrew runs both of those through sudo (the
  # launchctl one tries a second, root pass; delete runs 'sudo xargs rm' even on files in the user's own home), so every upgrade, reinstall
  # and uninstall asked for the administrator password to remove files the user owns. Nothing here needs a privilege: the daemon is a
  # per-user LaunchAgent in the gui domain, and no step says sudo. The order is the one the directives had: service, quit, then files.
  # A step's arguments may only be literals, so the user's id is read by a shell (id -u), not written into the cask.
  uninstall_preflight_steps do
    run "/bin/sh",
        args:         ["-c", "/bin/launchctl bootout gui/$(/usr/bin/id -u)/co.magicorn.warden-daemon"],
        must_succeed: false,
        print_stderr: false
  end

  uninstall quit:       "net.magicorn.warden.app",
            signal:     [["TERM", "net.magicorn.warden.app"]],
            on_upgrade: :signal

  uninstall_postflight_steps do
    remove [
      "Library/LaunchAgents/co.magicorn.warden-daemon.plist",
      "Library/Preferences/net.magicorn.warden.app.plist",
      "Library/Preferences/net.magicorn.warden.daemon.plist",
      "Library/Caches/net.magicorn.warden.app",
      "Library/Caches/net.magicorn.warden.daemon",
      "Library/Application Support/net.magicorn.warden.app",
      "Library/Saved Application State/net.magicorn.warden.app.savedState",
    ], base: :home, recursive: true
  end
end
