cask "warden" do
  arch arm: "arm64", intel: "x86_64"

  version "0.2.4"
  sha256 arm:   "5fa006e4f1d87b1f7099b2a8fc6aebc1f313c628934c1e7486403279947b2139",
         intel: "2e63684e70299db2a5378214f68479cd303340916471974521bbf2613aa3d300"

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
