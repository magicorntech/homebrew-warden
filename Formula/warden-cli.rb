class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.8.0/warden-0.8.0-darwin-arm64.tar.gz"
      sha256 "be1950d5d272a23088977f669e9c9e7d42c9d2ed23834a2cc399fd134f1cb742"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.8.0/warden-0.8.0-darwin-amd64.tar.gz"
      sha256 "6e0733576b041c64b76cf3c364022e86e94440b25a206aa0d80a681854e74eb0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.8.0/warden-0.8.0-linux-arm64.tar.gz"
      sha256 "cb29bbcee361575b24346f557322108d6da51d6748b1b2340735a7c7b7c8ca69"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.8.0/warden-0.8.0-linux-amd64.tar.gz"
      sha256 "9fe29372bfd4168bbdfb204e467cc397d1720aaf84cd817bddddcdaddbf05b99"
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
