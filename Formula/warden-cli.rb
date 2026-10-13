class WardenCli < Formula
  desc "Identity-native infrastructure access: short-lived certificates, no standing keys"
  homepage "https://github.com/magicorntech/homebrew-warden"
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.1.0/warden-0.1.0-darwin-arm64.tar.gz"
      sha256 "c48948e58d1e68d8fb822ffe9a70a4cd221aa7ad3e2287ceaf6dca295cae6b6d"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.1.0/warden-0.1.0-darwin-amd64.tar.gz"
      sha256 "585eb9b9b6d6abd4f71b80c9e0857af6fb31869582c938caa2e96a6a3a8c1030"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.1.0/warden-0.1.0-linux-arm64.tar.gz"
      sha256 "d23b088d2a433361ca5807b30c78d8b87f0e703efa0f260c180cc342bd16cfc4"
    end
    on_intel do
      url "https://github.com/magicorntech/homebrew-warden/releases/download/v0.1.0/warden-0.1.0-linux-amd64.tar.gz"
      sha256 "a7f6fe69c9cbf0da3d25ec0911137815c6dff83cceb4f5f359ba4c0dde82622d"
    end
  end

  def install
    bin.install "warden"
  end

  def caveats
    <<~EOS
      Sign in:                warden login --addr <your Warden login address>
      Keep the login fresh:   warden daemon install --cluster <name>
      On macOS, pairing this machine's Secure Enclave key needs the Warden app (the bare CLI cannot reach it).
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/warden version")
  end
end
