class IncusSpawnDev < Formula
  desc "CLI tool for managing isolated Incus-based development environments (dev channel)"
  homepage "https://github.com/Sanne/incus-spawn"
  version "0.5.4-dev.1"
  license "Apache-2.0"

  url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-aarch64"
  sha256 "95f471a883498645e7ee9252ce2f3e99ff881031f4f2e4f00dabe205933d8954"

  depends_on macos: :sequoia
  depends_on arch: :arm64

  conflicts_with "incus-spawn", because: "both install the `isx` binary"

  resource "isx-proxy" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.4-dev.1/isx-proxy-macos-aarch64"
    sha256 "0c9af380d8a0a82c7e08760400b958bafae3043dd4a4b949e5b78edeb9016bb2"
  end

  resource "isx-vm" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.4-dev.1/isx-vm-macos-aarch64"
    sha256 "21a5a7c17c5532c5b1d20bfc1d18d90ca5d844a82a5e81829ff3b686aae896ac"
  end

  resource "git-remote-isx" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.4-dev.1/git-remote-isx"
    sha256 "3a0d717f18c6d35fc27266e291e3b91f725cdc17b272db7b2995abe4b72cf4b6"
  end

  resource "completions" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.4-dev.1/completions.tar.gz"
    sha256 "1919cb1db0b287661f61a596d3b74f46cb86810464725f0027f1def7ced6dbfc"
  end

  def install
    bin.install "incus-spawn-macos-aarch64" => "isx"

    resource("isx-proxy").stage do
      bin.install "isx-proxy-macos-aarch64" => "isx-proxy"
    end

    resource("isx-vm").stage do
      bin.install "isx-vm-macos-aarch64" => "isx-vm"
    end

    resource("git-remote-isx").stage do
      bin.install "git-remote-isx"
    end

    resource("completions").stage do
      bash_completion.install "isx.bash" => "isx"
      zsh_completion.install "_isx"
      fish_completion.install "isx.fish"
    end
  end

  def caveats
    <<~EOS
      incus-spawn (dev) has been installed as 'isx'.

      This is the development channel — expect frequent updates.
      For the stable release, use: brew install Sanne/tap/incus-spawn

      First-time setup (required):
        isx init

      Documentation: https://github.com/Sanne/incus-spawn
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/isx --version")
  end
end
