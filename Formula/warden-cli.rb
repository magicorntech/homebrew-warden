class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.4.0/warden-0.4.0-darwin-arm64.tar.gz"
      sha256 "9841c669ac9238dab773602eec2dc3074a4750088b11d2c54f5e49b7d90428b6"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.4.0/warden-0.4.0-darwin-amd64.tar.gz"
      sha256 "af8ad9b547c189c0e76a7038c3c56323470d4f7b0c0029d1e48f705c9f174ac5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.4.0/warden-0.4.0-linux-arm64.tar.gz"
      sha256 "c8d13df6410c219046a0e1dc89f0ba7408fb49aaa505aa5288f76cc6065a2232"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.4.0/warden-0.4.0-linux-amd64.tar.gz"
      sha256 "ca96eac614b63d59cf307dbb418b653b2c80bb3f3b0c5156bbdc2bfd5431a185"
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
