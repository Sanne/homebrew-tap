class IncusSpawnDev < Formula
  desc "CLI tool for managing isolated Incus-based development environments (dev channel)"
  homepage "https://github.com/Sanne/incus-spawn"
  version "0.3.2-dev.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-aarch64"
      sha256 "a601f315a2bc0b9c5462d4e61221bdd99f8d634418f32f02e467690897640bc0"
    else
      url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-x86_64"
      sha256 "96cebfd3539b6a3b5309cbb5d0faa3e501d404dc30c7c0b5ad33f95b0ebc3a69"
    end
  end

  depends_on "vfkit"

  conflicts_with "incus-spawn", because: "both install the `isx` binary"

  resource "isx-proxy" do
    on_macos do
      on_arm do
        url "https://github.com/Sanne/incus-spawn/releases/download/v0.3.2-dev.5/isx-proxy-macos-aarch64"
        sha256 "57be1b6faa722826b103fc24f4fc3f6c21bda533b74311b2250c25b155b19c37"
      end
      on_intel do
        url "https://github.com/Sanne/incus-spawn/releases/download/v0.3.2-dev.5/isx-proxy-macos-x86_64"
        sha256 "f956dc6189df71df6f59e4201bde40c8db461eca3aaf40e3a46a150a6dfb30a5"
      end
    end
  end

  resource "git-remote-isx" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.3.2-dev.5/git-remote-isx"
    sha256 "23dce674bcceed571f2c7760143d8bbf08aae1f903c3cf398f5256b0bf1cfa10"
  end

  resource "completions" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.3.2-dev.5/completions.tar.gz"
    sha256 "15e94f096f04a6555c80575697d79186408024dafdd00adb0178727f75ff960d"
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
