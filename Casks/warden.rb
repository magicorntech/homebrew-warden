cask "warden" do
  arch arm: "arm64", intel: "x86_64"

  version "0.5.1"
  sha256 arm:   "c4e96a805141d8cfb26056abb9356ba2f9fd3c5395d93f67de34198004a86a2f",
         intel: "37b1bcb6742b4ed389ceb05f2c694fa11cf94ff500a302b10c6b8d1daeaceaae"

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

  # Removing OR UPGRADING the app removes everything of the running app: it is quit first (a menu-bar app keeps running after its files go;
  # TERM too if it ignores the quit, also on an upgrade), the daemon service is unloaded and its agent file deleted (an upgrade registers the new
  # one in its postflight), and on a removal the app's own settings and caches are deleted. NOT touched: ~/.warden, the user's logins, device
  # pairing and logs, which are the user's and survive a reinstall.
  uninstall quit:       "net.magicorn.warden.app",
            signal:     [["TERM", "net.magicorn.warden.app"]],
            on_upgrade: :signal,
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
