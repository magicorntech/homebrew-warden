cask "warden" do
  arch arm: "arm64", intel: "x86_64"

  version "0.6.1"
  sha256 arm:   "2adac5897dd3e35b4ed949e21006c917a3afdbf8f2f6d8dad0c64e9bf9947de4",
         intel: "052ed4de3913940366f9270328f2c3a7b8fded83af70b3d727c16bc1e894ebd4"

  url "https://github.com/magicorntech/homebrew-warden/releases/download/v#{version}/Warden-#{version}-#{arch}.zip"
  name "Warden"
  desc "Menu-bar client for Warden: keeps your sign-in fresh and pairs this Mac's Secure Enclave"
  homepage "https://github.com/magicorntech/homebrew-warden"

  depends_on macos: ">= :sonoma"

  # Installed as Warden.app, the same name the disk image uses, so an app installed either way is the same app in the same place.
  app "WardenApp.app", target: "Warden.app"

  # The daemon is the app's own (WardenDaemon.app inside the bundle: only that executable can reach the Secure Enclave), registered as a
  # LaunchAgent so it runs at every login whether or not the app is open. Installing it is 'warden daemon install', run as the user.
  postflight do
    system_command "#{appdir}/Warden.app/Contents/Library/WardenDaemon.app/Contents/MacOS/warden",
                   args: ["daemon", "install"]
  end

  # Removing OR UPGRADING the app removes everything of the running app: the daemon service is unloaded first, then the app is quit (a
  # menu-bar app keeps running after its files go; TERM too if it ignores the quit, also on an upgrade), then the agent file is deleted (an
  # upgrade registers the new one in its postflight), and on a removal the app's own settings and caches are deleted. NOT touched: ~/.warden,
  # the user's logins, device pairing and logs, which are the user's and survive a reinstall.
  #
  # Done with blocks, not with the 'launchctl:' and 'delete:' directives, for one reason: Homebrew runs both of those through sudo (the
  # launchctl one tries a second, root pass; delete runs 'sudo xargs rm' even on files in the user's own home), so every upgrade, reinstall
  # and uninstall asked for the administrator password to remove files the user owns. Nothing here needs a privilege: the daemon is a
  # per-user LaunchAgent in the gui domain. The order is the one the directives had: service, quit, then files.
  uninstall_preflight do
    system_command "/bin/launchctl", args: ["bootout", "gui/#{Process.uid}/co.magicorn.warden-daemon"],
                                     must_succeed: false, print_stderr: false
  end

  uninstall quit:       "net.magicorn.warden.app",
            signal:     [["TERM", "net.magicorn.warden.app"]],
            on_upgrade: :signal

  uninstall_postflight do
    [
      "~/Library/LaunchAgents/co.magicorn.warden-daemon.plist",
      "~/Library/Preferences/net.magicorn.warden.app.plist",
      "~/Library/Preferences/net.magicorn.warden.daemon.plist",
      "~/Library/Caches/net.magicorn.warden.app",
      "~/Library/Caches/net.magicorn.warden.daemon",
      "~/Library/Application Support/net.magicorn.warden.app",
      "~/Library/Saved Application State/net.magicorn.warden.app.savedState",
    ].each { |f| FileUtils.rm_rf(File.expand_path(f)) }
  end
end
