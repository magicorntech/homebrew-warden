class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  # The standalone command-line package is discontinued: the warden command comes with the Warden app (the cask), which is
  # the only build that can reach this Mac's Secure Enclave. Linux is not a client platform.
  disable! date: "2026-11-12", because: "is discontinued: the warden command now comes with the Warden app", replacement_cask: "magicorntech/warden/warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.3/warden-0.9.3-darwin-arm64.tar.gz"
      sha256 "0bb51c9e81df5e10e91fef8cd010d17fd3557e53a37b282bc1aa6de7d2dacc37"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.3/warden-0.9.3-darwin-amd64.tar.gz"
      sha256 "d056bfc5ff1449824fea81453cf22a92e2fed732d1a219e52b969b9425848ab6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.3/warden-0.9.3-linux-arm64.tar.gz"
      sha256 "dd6bea7092f8f3c8b09233075fea6f2a2d62b10705a2393cbed14f67e7a2de1c"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.3/warden-0.9.3-linux-amd64.tar.gz"
      sha256 "52fe0368f4ec23b0be18650d75df3872352a3e5035f33d3acf3bf5cfe5df3f56"
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
