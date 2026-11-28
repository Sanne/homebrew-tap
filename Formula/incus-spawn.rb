class IncusSpawn < Formula
  desc "CLI tool for managing isolated Incus-based development environments"
  homepage "https://github.com/Sanne/incus-spawn"
  version "0.6.1"
  license "Apache-2.0"

  url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-aarch64"
  sha256 "bec1510b3059701b57fcba2ad0cddedb33a96c26085ed43cc568bbe8b9169016"

  depends_on macos: :sequoia
  depends_on arch: :arm64

  resource "isx-proxy" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.6.1/isx-proxy-macos-aarch64"
    sha256 "37a50cae8b496fbda63917874ef65f7ed840d9405d999fb96f983d2498f53f2e"
  end

  resource "isx-vm" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.6.1/isx-vm-macos-aarch64"
    sha256 "5baf2655900dce8f4f4b3652b39d276c2362706879ba988bd25ac8f1a1385370"
  end

  resource "git-remote-isx" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.6.1/git-remote-isx"
    sha256 "3a0d717f18c6d35fc27266e291e3b91f725cdc17b272db7b2995abe4b72cf4b6"
  end

  resource "completions" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.6.1/completions.tar.gz"
    sha256 "94ca80d0f54c4c1725e22ae1e665ecd73b57b44d8182f86a1feecb743da367e6"
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

      Upgrading from isx 0.5.3 or earlier, whose VM ran under vfkit:
        quit the isx TUI and every isx mcp, then run
        isx proxy restart
        isx vm restart
      Afterwards brew autoremove removes vfkit. Details:
      https://isx.run/docs/faq#how-do-i-upgrade-a-mac-whose-vm-ran-with-vfkit

      Documentation: https://github.com/Sanne/incus-spawn
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/isx --version")
  end
end
