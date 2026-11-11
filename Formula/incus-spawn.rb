class IncusSpawn < Formula
  desc "CLI tool for managing isolated Incus-based development environments"
  homepage "https://github.com/Sanne/incus-spawn"
  version "0.5.1"
  license "Apache-2.0"

  url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-aarch64"
  sha256 "338bb1e2e7560070694ff84cec8c32f6a635916de57838205afd50bea24450be"

  depends_on macos: :sequoia
  depends_on arch: :arm64
  depends_on "vfkit"

  resource "isx-proxy" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.1/isx-proxy-macos-aarch64"
    sha256 "5c8ae6990ffda6b7d36178b2cf1bf78846324034968bc11eea0397f3f47acac9"
  end

  resource "git-remote-isx" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.1/git-remote-isx"
    sha256 "3a0d717f18c6d35fc27266e291e3b91f725cdc17b272db7b2995abe4b72cf4b6"
  end

  resource "completions" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.1/completions.tar.gz"
    sha256 "f258ef7d2c05f2616b20dbb369cafc83296da45e8c644156816e618cb63af4fd"
  end

  def install
    bin.install "incus-spawn-macos-aarch64" => "isx"

    resource("isx-proxy").stage do
      bin.install "isx-proxy-macos-aarch64" => "isx-proxy"
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
      incus-spawn has been installed as 'isx'.

      First-time setup (required):
        isx init

      This will:
        - Generate MITM CA certificate
        - Configure Claude API and GitHub credentials
        - Install VM and proxy as macOS services (auto-start at login)

      To build your first template:
        isx build tpl-java

      To launch the interactive TUI:
        isx

      Documentation: https://github.com/Sanne/incus-spawn
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/isx --version")
  end
end
