class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.0/warden-0.2.0-darwin-arm64.tar.gz"
      sha256 "fbbf32f8ae11f32b304ad8aa0e578080543b70a033324d37e90349d9bd1eab59"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.0/warden-0.2.0-darwin-amd64.tar.gz"
      sha256 "2bf09e81c8374d29ae5df733891a3da5b79fe51fee1029711e1ae345b7bacc8b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.0/warden-0.2.0-linux-arm64.tar.gz"
      sha256 "e94b8999947a66d75a737f6c2a40dac7ecfeba02f1db3a7b54be4ebd401a5fb3"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.2.0/warden-0.2.0-linux-amd64.tar.gz"
      sha256 "cac0d00454097611e7ec93010971faf9034bb82386cb2ec5592ab5cd31bf9d48"
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
