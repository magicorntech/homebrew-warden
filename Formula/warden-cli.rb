class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.2/warden-0.9.2-darwin-arm64.tar.gz"
      sha256 "ebe40da0dd8dcefabaf365a97428229920689bf6d6da3a45dcb4819cbe6aa4d0"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.2/warden-0.9.2-darwin-amd64.tar.gz"
      sha256 "bcb4ea7192643aa773e3b2adfc64cebc4fe92c6eefe18911ee219120d21d20d2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.2/warden-0.9.2-linux-arm64.tar.gz"
      sha256 "5619c0df0efdc398b751f453f2c192ca3a81ab51b9b0ffae1af6a4a3e05f3bca"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.2/warden-0.9.2-linux-amd64.tar.gz"
      sha256 "82482599a6c4d95457c919652deec4c93e62ba7c634c296c673b338c621921e1"
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
