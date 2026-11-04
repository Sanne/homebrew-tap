class IncusSpawnDev < Formula
  desc "CLI tool for managing isolated Incus-based development environments (dev channel)"
  homepage "https://github.com/Sanne/incus-spawn"
  version "0.5.0-dev.2"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-aarch64"
      sha256 "ffe0b2a30e63b1a946571f3c926b0ddd3a8eac826caeb25271608375f0e34fc1"
    else
      url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-x86_64"
      sha256 "29cdbf01761d813a75c205ac0231ec0d6858c8c15fe88143a500a34fd33bcd39"
    end
  end

  depends_on macos: :sequoia
  depends_on "vfkit"

  conflicts_with "incus-spawn", because: "both install the `isx` binary"

  resource "isx-proxy" do
    on_macos do
      on_arm do
        url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.0-dev.2/isx-proxy-macos-aarch64"
        sha256 "be258a3593bc4d02099c7f52342ac768847c1d0d02d9e485ea8b973dc518d30d"
      end
      on_intel do
        url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.0-dev.2/isx-proxy-macos-x86_64"
        sha256 "a217a3f5aca5ad121fd7528fe663ba0cdf352fb52dbdd8345c626b82d0244d82"
      end
    end
  end

  resource "git-remote-isx" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.0-dev.2/git-remote-isx"
    sha256 "3a0d717f18c6d35fc27266e291e3b91f725cdc17b272db7b2995abe4b72cf4b6"
  end

  resource "completions" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.0-dev.2/completions.tar.gz"
    sha256 "262f4452507151e2b420a8619184def020a14a7c081d75eda097d92558a8c441"
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
