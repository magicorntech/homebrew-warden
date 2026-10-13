class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.3/warden-0.2.3-darwin-arm64.tar.gz"
      sha256 "f6b6c5cf7279f8faf3ca3315b15337aa86c1654103bf81e22b6c6a6aae8243e2"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.3/warden-0.2.3-darwin-amd64.tar.gz"
      sha256 "289efc8e96d1fbfd6b5aaaf56dc8d4b2eb3715c6656ce420010d0aa4ff5e7b5b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.3/warden-0.2.3-linux-arm64.tar.gz"
      sha256 "ea01b6913b3da4db93ecfd9775e5f200f10d51a4ebbffcd5a532696ca76f03ff"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.3/warden-0.2.3-linux-amd64.tar.gz"
      sha256 "4ed0eca7d8d596ea8d75c0241087db18f28f7c5b0af79ea04e89e69fda8c5fc6"
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
        warden login --cluster <name> --addr <your Warden login address>
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
