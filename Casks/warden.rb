cask "warden" do
  version "0.1.0"
  sha256 "19902e24c3783ac13867dc074be676542af31698f359898d536dfc1f3adb81e8"

  url "https://github.com/magicorntech/homebrew-warden/releases/download/v#{version}/Warden-#{version}.zip"
  name "Warden"
  desc "Menu-bar client for Warden: keeps your sign-in fresh and pairs this Mac's Secure Enclave"
  homepage "https://github.com/magicorntech/homebrew-warden"

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  app "WardenApp.app"
end
