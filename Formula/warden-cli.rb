class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.1/warden-0.5.1-darwin-arm64.tar.gz"
      sha256 "d3cc87bdda10a1b6655fdbbbb371a3d29461f20dca72c375ab6e2f7be5782bb1"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.1/warden-0.5.1-darwin-amd64.tar.gz"
      sha256 "7fe1804d80300d1fc36a4ccb83d2525844c1c751b265699554e4495d5f0952e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.1/warden-0.5.1-linux-arm64.tar.gz"
      sha256 "148434c3260d8a0be5755d4ea93711dab562126e01144d62a092c257b83370d2"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.5.1/warden-0.5.1-linux-amd64.tar.gz"
      sha256 "5d05d3622bedadebd0f48ac5de6e5f7311578bcca3418c10b81a66a69ec19c11"
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
