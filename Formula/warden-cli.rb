class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.5/warden-0.2.5-darwin-arm64.tar.gz"
      sha256 "a43f91cb83e9317a2d49f5fea624064ab300af68e646b64407e9e730dba82eef"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.5/warden-0.2.5-darwin-amd64.tar.gz"
      sha256 "27b6fb1d59dd00ed9289c00ca6fd5525851e5b72f565851b11e84c2b1850de3a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.5/warden-0.2.5-linux-arm64.tar.gz"
      sha256 "7789783f02f317f7d3c192493b02c19d56d87e5365d07ea4194fa2b299222faa"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.5/warden-0.2.5-linux-amd64.tar.gz"
      sha256 "69875b280d2a7028673992fd15a2bf53836de90d4ab6003190e1ed665d5675fd"
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
