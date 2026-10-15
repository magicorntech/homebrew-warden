class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.3.1/warden-0.3.1-darwin-arm64.tar.gz"
      sha256 "68cfcc7828203ea23875a9b81e4dd7a581eb8d70aee4c85ab53d8ee598efa39e"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.3.1/warden-0.3.1-darwin-amd64.tar.gz"
      sha256 "9b73c50ce13de05fb6f0ef3b2de5db2c8dfb269f986a24b8a59ab018fe53f962"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.3.1/warden-0.3.1-linux-arm64.tar.gz"
      sha256 "b89541a91b92194c10b2a871a02a5b70363640f8aa8701c9a825ca24de30bc81"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.3.1/warden-0.3.1-linux-amd64.tar.gz"
      sha256 "377a0c045892d3452195c322a79ec0fe49e72e425cef967ec1ba3450837d6a9d"
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
