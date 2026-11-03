class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.6/warden-0.5.6-darwin-arm64.tar.gz"
      sha256 "a747711667ec03db22382320ff88a14851f39e31cd0ccabfe1266c8f5189c545"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.6/warden-0.5.6-darwin-amd64.tar.gz"
      sha256 "0bae7ffe388b0190c677aadcf022a5000746fec6662c911118a7da4ad45efc5c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.6/warden-0.5.6-linux-arm64.tar.gz"
      sha256 "0a322f0b0fe5a58b7a1a23a836a68464d1be940132bedbe647ed77558e5cb809"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.6/warden-0.5.6-linux-amd64.tar.gz"
      sha256 "8088422439000d4b8aebeb1a24bc8b9188f6c43ce0248dc475442f624965ce78"
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
