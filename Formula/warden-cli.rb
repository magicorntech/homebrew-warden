class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.0/warden-0.9.0-darwin-arm64.tar.gz"
      sha256 "4c18e6a2d59b75e978581035a01ecc26e6baf3f00827587499f715f347a53576"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.0/warden-0.9.0-darwin-amd64.tar.gz"
      sha256 "cf83152d7e5b76b690243fd918708cd5a10a58abca5474ad9bc038a34c34cb60"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.0/warden-0.9.0-linux-arm64.tar.gz"
      sha256 "23527a308e8ea19905939b599f36190520822fac6817396ced7373963251ac3b"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.9.0/warden-0.9.0-linux-amd64.tar.gz"
      sha256 "3d229bb4392ce22ec259f7a0e099b4789630bbebb8d05efa5cd02e1c313bbd1f"
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
