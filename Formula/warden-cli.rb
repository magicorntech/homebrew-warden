class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.7.0/warden-0.7.0-darwin-arm64.tar.gz"
      sha256 "e15e406fbdd0793c431860a3ad2335e38909514c933ab5a6cd83a30aa897d646"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.7.0/warden-0.7.0-darwin-amd64.tar.gz"
      sha256 "9363cba25dc955bb854a392fc4e8370e0271c7992e24a9b33ec75eea04005a59"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.7.0/warden-0.7.0-linux-arm64.tar.gz"
      sha256 "90e0bca806e3fd4bf64aaa905f5f9d2bd1032d21817b9e3fc38a6ec6777fba50"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.7.0/warden-0.7.0-linux-amd64.tar.gz"
      sha256 "e9ed1d95a2ddf5483287921ea5d8256a760fcbe786f296c7e159ec5ff5b446ad"
    end
  end

  def install
    bin.install "warden"
  end

  # One daemon per user serves every cluster you sign in to (docs/DAEMON.md).
  # 'brew services start warden-cli' runs it as a launchd agent or systemd user
  # service; --wait-for-lock makes a second daemon (the app's, or the one that
  # 'warden daemon install' sets up) wait instead of failing.
  service do
    run [opt_bin/"warden", "daemon", "serve", "--wait-for-lock"]
    keep_alive true
    log_path var/"log/warden-daemon.log"
    error_log_path var/"log/warden-daemon.log"
  end

  def caveats
    <<~EOS
      Start the daemon (one for every cluster, kept running in the background):
        brew services start warden-cli
      Then sign in; the daemon picks the cluster up by itself:
        warden login <your Warden address, e.g. warden.example.com>
      Before removing the package, stop the service (brew does not do it for you):
        brew services stop warden-cli
      On macOS, use the Warden app instead (brew install --cask magicorntech/warden/warden): pairing this Mac's Secure Enclave key
      needs the app's own daemon, which this command-line build cannot provide.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/warden version")
  end
end
