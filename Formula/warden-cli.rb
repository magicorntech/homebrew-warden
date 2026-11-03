class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.4/warden-0.5.4-darwin-arm64.tar.gz"
      sha256 "832ce30d656a2b68c7d0c7a494e3d6da1ca3c05882a60377bea5876b96b5b54e"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.4/warden-0.5.4-darwin-amd64.tar.gz"
      sha256 "f9f2b58f879d1c66c49d04dd24ca9c6a15302500adda0841b8cd6ae822a9f351"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.4/warden-0.5.4-linux-arm64.tar.gz"
      sha256 "44a98fe744523ad90b29ddb5f8a50db65f24542d0a28094f951803630621c535"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.4/warden-0.5.4-linux-amd64.tar.gz"
      sha256 "78322d301d13260edbc43257783ab8f0f1503cf25869816849b1dbf643693f25"
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
