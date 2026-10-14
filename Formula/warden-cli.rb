class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.3.0/warden-0.3.0-darwin-arm64.tar.gz"
      sha256 "22030586e7f048a2b82e9b24bf3c6509a24b84b39a6c241b55bae6c29ac2f8ad"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.3.0/warden-0.3.0-darwin-amd64.tar.gz"
      sha256 "8ddf136184653715cc7fc129f8622264581b40d112ae52cc75ea787baec4001a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.3.0/warden-0.3.0-linux-arm64.tar.gz"
      sha256 "596375e9a64815074cc3c476fe2f36113f6a848cee787eef585eccb736f64624"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.3.0/warden-0.3.0-linux-amd64.tar.gz"
      sha256 "f781c3b34d34cf00ce214695fc0b8b95a7d6658c125e565d5efc7bb4005d4a16"
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
