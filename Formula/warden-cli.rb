class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates only"
  homepage "https://github.com/magicorntech/homebrew-warden"

  # The standalone command-line package is discontinued: the warden command comes with the Warden app (the cask), which is
  # the only build that can reach this Mac's Secure Enclave. This formula stays only so that Homebrew can say so and name the
  # cask; it cannot be installed, and the archives it used to download have been removed from the releases.
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

  def install
    bin.install "warden"
  end

  # Kept for a copy installed before the package was discontinued, so that 'brew services stop warden-cli' still finds its service.
  service do
    run [opt_bin/"warden", "daemon", "serve", "--wait-for-lock"]
    keep_alive true
    log_path var/"log/warden-daemon.log"
    error_log_path var/"log/warden-daemon.log"
  end

  def caveats
    <<~EOS
      warden-cli is discontinued. The warden command now comes with the Warden app:
        brew services stop warden-cli   (if you started it)
        brew uninstall warden-cli
        brew install --cask magicorntech/warden/warden
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/warden version")
  end
end
