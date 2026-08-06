cask "linkbar" do
  version "1.2.1"
  sha256 "04d1b4c7d09b78ccafb76933ccdf93f9c4a6a6f3461541c8542d202ed5e87a96"

  url "https://github.com/gowtham0992/link/releases/download/v2.2.1/LinkBar-#{version}.zip"
  name "LinkBar"
  desc "Link's agent memory, ambient in the menu bar"
  homepage "https://github.com/gowtham0992/link"

  depends_on formula: "gowtham0992/link/link"
  depends_on macos: :sonoma

  app "LinkBar.app"

  # LinkBar ships unsigned (open source, no Apple Developer certificate).
  # Homebrew quarantines staged apps by default, which would block first
  # launch of an unsigned bundle; clearing the flag here restores the normal
  # double-click experience. Verified on macOS 15 and 26.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/LinkBar.app"]
  end

  zap trash: []
end
