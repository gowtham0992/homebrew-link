cask "linkbar" do
  version "1.1.0"
  sha256 "80894b6271f67b1a9228941578229e7fc8886e4fa6ea51a08da67b343b28c15d"

  url "https://github.com/gowtham0992/link/releases/download/v2.1.0/LinkBar-#{version}.zip"
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
