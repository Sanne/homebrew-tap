class IncusSpawnDev < Formula
  desc "CLI tool for managing isolated Incus-based development environments (dev channel)"
  homepage "https://github.com/Sanne/incus-spawn"
  version "0.3.10-dev.1"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-aarch64"
      sha256 "08f7804c71c4c2c5ddcb41cf03b6adb6fed218b7bf9b50e8efa81714d3ec94f5"
    else
      url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-x86_64"
      sha256 "42d5dec3ae986b9f0acaed1df12899b0d9e0786c38533806466aae3cd23d8fd9"
    end
  end

  depends_on macos: :sequoia
  depends_on "vfkit"

  conflicts_with "incus-spawn", because: "both install the `isx` binary"

  resource "isx-proxy" do
    on_macos do
      on_arm do
        url "https://github.com/Sanne/incus-spawn/releases/download/v0.3.10-dev.1/isx-proxy-macos-aarch64"
        sha256 "2d379caa91a9d1232bbb2408eca159ffb39e3c16a835d6848d2f493bede456fb"
      end
      on_intel do
        url "https://github.com/Sanne/incus-spawn/releases/download/v0.3.10-dev.1/isx-proxy-macos-x86_64"
        sha256 "4a8030de0051dc46585f254e82f08f48461185e41bd2e84afa00b9b6e5e16853"
      end
    end
  end

  resource "git-remote-isx" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.3.10-dev.1/git-remote-isx"
    sha256 "23dce674bcceed571f2c7760143d8bbf08aae1f903c3cf398f5256b0bf1cfa10"
  end

  resource "completions" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.3.10-dev.1/completions.tar.gz"
    sha256 "db7fd57a649798be360601639fc2ae8f2b6325f420d9332f07b12d642332806b"
  end

  def install
    if Hardware::CPU.arm?
      bin.install "incus-spawn-macos-aarch64" => "isx"
    else
      bin.install "incus-spawn-macos-x86_64" => "isx"
    end

    resource("isx-proxy").stage do
      if Hardware::CPU.arm?
        bin.install "isx-proxy-macos-aarch64" => "isx-proxy"
      else
        bin.install "isx-proxy-macos-x86_64" => "isx-proxy"
      end
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
