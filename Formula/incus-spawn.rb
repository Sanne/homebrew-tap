class IncusSpawn < Formula
  desc "CLI tool for managing isolated Incus-based development environments"
  homepage "https://github.com/Sanne/incus-spawn"
  version "0.5.0"
  license "Apache-2.0"

  url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-aarch64"
  sha256 "f31d354dde92d15ba4aacb6abdad53bb29b5f9be1753ed2602ea91c174934f20"

  depends_on macos: :sequoia
  depends_on arch: :arm64
  depends_on "vfkit"

  resource "isx-proxy" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.0/isx-proxy-macos-aarch64"
    sha256 "f00a66a2eea73acbf332b1f810e74adff354ccc9450835ae613e1cf02b703bb1"
  end

  resource "git-remote-isx" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.0/git-remote-isx"
    sha256 "3a0d717f18c6d35fc27266e291e3b91f725cdc17b272db7b2995abe4b72cf4b6"
  end

  resource "completions" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.5.0/completions.tar.gz"
    sha256 "c29b8d418cd995b022abf1aaf9df5ec86242a29509c8d4b72c650f54d01538f6"
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
