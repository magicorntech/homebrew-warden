class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.3/warden-0.5.3-darwin-arm64.tar.gz"
      sha256 "a80a3b49134d42dee13b43a63263f1ab8d4fe877dbc193f9f47f65b024d74bae"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.3/warden-0.5.3-darwin-amd64.tar.gz"
      sha256 "0b35b7e3e508e7be5f2823489332d1b233242dce93e3293b0c27b179dfa3ca52"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.3/warden-0.5.3-linux-arm64.tar.gz"
      sha256 "53e1d043125332eddcedb864116ed28ad16e2a8fd94e1f3d3ed627ad05af9724"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.3/warden-0.5.3-linux-amd64.tar.gz"
      sha256 "047663eaecd2948952ca11e8ae6b75ae0b70ddac3ebb9a2140ddb81ee09b206b"
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
