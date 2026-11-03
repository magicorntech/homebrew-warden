class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.7/warden-0.5.7-darwin-arm64.tar.gz"
      sha256 "76bfb407f948361fb8d281836237266cd75a25e5bbaf852feccc51b3764820a4"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.7/warden-0.5.7-darwin-amd64.tar.gz"
      sha256 "cb0a2087f6649815f5ae32f1c96da4217d2d934cb7eca6267074f7486faf12ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.7/warden-0.5.7-linux-arm64.tar.gz"
      sha256 "89c2f8e5a3be9c2fe54aead378fe6d48cb7de0131553ba191ae7508a9228c680"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.7/warden-0.5.7-linux-amd64.tar.gz"
      sha256 "82cc68f7d41b5f79f8a76ed45ffd79918906cd4c320acbdb8f6da9937b496ad9"
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
