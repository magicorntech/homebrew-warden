class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.8.1/warden-0.8.1-darwin-arm64.tar.gz"
      sha256 "645bc87bf132da59dccaa88013e9c7351d462f3bcde46d2e8fcf8cceafef9d87"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.8.1/warden-0.8.1-darwin-amd64.tar.gz"
      sha256 "8b08778d11e9df9125c11e7d3c149903a9c867b510a975417df769b7ebfb08ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.8.1/warden-0.8.1-linux-arm64.tar.gz"
      sha256 "2f199496af56d47cf300ed9a57936c2e2e6e06d10e09af1c7a76245b5dddb1ce"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.8.1/warden-0.8.1-linux-amd64.tar.gz"
      sha256 "175a3394cb61068e4b2a563ee2c7e8415a15c6b58270c8236c801bb6a98d7d72"
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
