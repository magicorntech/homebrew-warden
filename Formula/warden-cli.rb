class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.6.0/warden-0.6.0-darwin-arm64.tar.gz"
      sha256 "1e3bb3242e6100c7a02cf1f9aecedab88bef57085a5902d2b72778b09aff5767"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.6.0/warden-0.6.0-darwin-amd64.tar.gz"
      sha256 "1053a4a2ef9a9ac547a21e968d10c5223134a7cc03c1320861b2c5ba837639c5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.6.0/warden-0.6.0-linux-arm64.tar.gz"
      sha256 "4dfb0ae93a1411d6f8d42cf4569250d25822104e04ac8552fdad7c38040d6e38"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.6.0/warden-0.6.0-linux-amd64.tar.gz"
      sha256 "7d83cd1f814f27a7992416f7ad97555a6b2021270ff30d4b6b96b662848a6f84"
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
