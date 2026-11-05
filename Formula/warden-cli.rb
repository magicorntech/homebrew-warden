class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.6.1/warden-0.6.1-darwin-arm64.tar.gz"
      sha256 "589e1eb232bf0f0b28424177de84e38a378aebbbc800f7047b3ab605a6fb3178"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.6.1/warden-0.6.1-darwin-amd64.tar.gz"
      sha256 "e9f23915357998d611c7fdc9c2c75b7144cedb4ec0a9f79edc1d95069eaee292"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.6.1/warden-0.6.1-linux-arm64.tar.gz"
      sha256 "382a2eca57f51d886a93c7fea5b677ab2ec39b01e38a16cab055fb9b56ce3f5a"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.6.1/warden-0.6.1-linux-amd64.tar.gz"
      sha256 "f3dad6a05d39ddf4cccc57f37badd16a1ca4a2adfd1119b942996e218e539726"
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
