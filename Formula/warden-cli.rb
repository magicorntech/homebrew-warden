class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.4/warden-0.2.4-darwin-arm64.tar.gz"
      sha256 "34fb60d44edbf8c333f955a46f54b1ac06c0a0ee64d1bd373c3c4ab87dae871a"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.4/warden-0.2.4-darwin-amd64.tar.gz"
      sha256 "4304b7d5c77f1a486ffd859a2f9a934785622b6149dc7bf8bfe5e903f4ce76d7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.4/warden-0.2.4-linux-arm64.tar.gz"
      sha256 "0001edd8cc4581489330cc4c2fd00930df8db143ac2a83c3a2706e66e991c9a5"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.4/warden-0.2.4-linux-amd64.tar.gz"
      sha256 "16d478a0915a71111b312ff445dddf7d2f92c668d418c14855a65946ef4df9b7"
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
