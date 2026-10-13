class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.1/warden-0.2.1-darwin-arm64.tar.gz"
      sha256 "3b03549caae6a7ee4534b315b375fe80bc62f2dd947707af7b8f2b22ae7350c2"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.1/warden-0.2.1-darwin-amd64.tar.gz"
      sha256 "065a22add00d1eb35bcd5905557182ecf8566703bad2f14255bdc5045b051856"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.1/warden-0.2.1-linux-arm64.tar.gz"
      sha256 "78f6071ddc0b0cc0c6a46497f9942278574bde55b7a9df57df5a3861c75dfb20"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.1/warden-0.2.1-linux-amd64.tar.gz"
      sha256 "43969c4776dd5e6ff55420cb03715bb36bd9661fb003d1a8778ca3b2e95195f2"
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
