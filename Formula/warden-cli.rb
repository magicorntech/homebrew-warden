class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.1/warden-0.9.1-darwin-arm64.tar.gz"
      sha256 "7e080d14d36ca49367a85f8bd414e1f391934a24cc6a4b4131a5b01a0a808d97"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.1/warden-0.9.1-darwin-amd64.tar.gz"
      sha256 "c3bcc75b844ceeda18cf511512f3dcc4c6ce7bdf8524a687d57ec74d5b4e394b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.1/warden-0.9.1-linux-arm64.tar.gz"
      sha256 "a4ad4c4f1f9446c97d9e96290863531c90ee11d0584f4383dcc3dbf56e6c83d5"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.1/warden-0.9.1-linux-amd64.tar.gz"
      sha256 "33edf3f681c0a4045f7f856587cdfa5a5031a114906e7f6a48ac473a57b98639"
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
