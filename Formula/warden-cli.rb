class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.2/warden-0.2.2-darwin-arm64.tar.gz"
      sha256 "ff8380d36abf229de7abc967989477e168accf2272d657cb1e26288b63ef5115"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.2/warden-0.2.2-darwin-amd64.tar.gz"
      sha256 "4894ca537a959cb744e84c506bac231fcb8a1ff7ab780a0f052032463f9d7120"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.2/warden-0.2.2-linux-arm64.tar.gz"
      sha256 "66b0a03aa9cfed69cde9a26f0b1e33ca5d8a724d8bc8545255060440bc77dbbe"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.2/warden-0.2.2-linux-amd64.tar.gz"
      sha256 "20d4f35443514056c1588fb51bc40b93a4f6112bf5b45f26bc144bb031e18a46"
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
