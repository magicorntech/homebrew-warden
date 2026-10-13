cask "warden" do
  version "0.2.2"
  sha256 "77dc09db587ef401f43934c7ee4f55bc6eb97826084dfd77712286215b5c51e8"

  url "https://github.com/magicorntech/homebrew-warden/releases/download/v#{version}/Warden-#{version}.zip"
  name "Warden"
  desc "Menu-bar client for Warden: keeps your sign-in fresh and pairs this Mac's Secure Enclave"
  homepage "https://github.com/magicorntech/homebrew-warden"

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  app "WardenApp.app"

  # The daemon is the app's own (WardenDaemon.app inside the bundle: only that executable can reach the Secure Enclave), registered as a
  # LaunchAgent so it runs at every login whether or not the app is open. Installing it is 'warden daemon install', run as the user.
  postflight do
    system_command "#{appdir}/WardenApp.app/Contents/Library/WardenDaemon.app/Contents/MacOS/warden",
                   args: ["daemon", "install"]
  end

  # Removing the app removes everything of the app: it is quit first (a menu-bar app keeps running after its files go), the daemon
  # service is unloaded and its agent file deleted, and the app's own settings and caches are deleted. NOT touched: ~/.warden, the
  # user's logins, device pairing and logs, which are the user's and survive a reinstall.
  uninstall quit:       "net.magicorn.warden.app",
            signal:     [["TERM", "net.magicorn.warden.app"]],
            launchctl:  "co.magicorn.warden-daemon",
            delete:     [
              "~/Library/LaunchAgents/co.magicorn.warden-daemon.plist",
              "~/Library/Preferences/net.magicorn.warden.app.plist",
              "~/Library/Preferences/net.magicorn.warden.daemon.plist",
              "~/Library/Caches/net.magicorn.warden.app",
              "~/Library/Caches/net.magicorn.warden.daemon",
              "~/Library/Application Support/net.magicorn.warden.app",
              "~/Library/Saved Application State/net.magicorn.warden.app.savedState",
            ]
end
