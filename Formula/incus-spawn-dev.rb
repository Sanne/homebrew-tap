class IncusSpawnDev < Formula
  desc "CLI tool for managing isolated Incus-based development environments (dev channel)"
  homepage "https://github.com/Sanne/incus-spawn"
  version "0.2.21-dev.8"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-aarch64"
      sha256 "85bddc0bc5d4907faaff6f242a15908ab3414a5900e66a6e7ea6d034b06a551a"
    else
      url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-x86_64"
      sha256 "0ce2ed3b5e5f65b8aec3b3214f4a4d2fd11fcffe63c0a51af0542d650eda28ab"
    end
  end

  depends_on "vfkit"

  conflicts_with "incus-spawn", because: "both install the `isx` binary"

  resource "isx-proxy" do
    on_macos do
      on_arm do
        url "https://github.com/Sanne/incus-spawn/releases/download/v0.2.21-dev.8/isx-proxy-macos-aarch64"
        sha256 "5a2069f9173bba2924372bce7d6e19a55087e06a57712d27074b067002ea5ebc"
      end
      on_intel do
        url "https://github.com/Sanne/incus-spawn/releases/download/v0.2.21-dev.8/isx-proxy-macos-x86_64"
        sha256 "c93897209d1cb3e1362a91d9fa0df5dc0e56e6e9fa3b4e405ac3f57ada152b5e"
      end
    end
  end

  resource "git-remote-isx" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.2.21-dev.8/git-remote-isx"
    sha256 "23dce674bcceed571f2c7760143d8bbf08aae1f903c3cf398f5256b0bf1cfa10"
  end

  resource "completions" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.2.21-dev.8/completions.tar.gz"
    sha256 "1e53b569273213d0bca7b628cb87669225a58e773fc8532759593179ba1cd5d6"
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
