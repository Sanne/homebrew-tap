class IncusSpawn < Formula
  desc "CLI tool for managing isolated Incus-based development environments"
  homepage "https://github.com/Sanne/incus-spawn"
  version "0.6.0"
  license "Apache-2.0"

  url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-aarch64"
  sha256 "43ca9c511800e7e5aebff552e98fb98ff833a0e2821301b31d1ad25a7f289981"

  depends_on macos: :sequoia
  depends_on arch: :arm64

  resource "isx-proxy" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.6.0/isx-proxy-macos-aarch64"
    sha256 "58029781ca57a4ff3dbf90ba414a01b151c3d93a5e16c4d1d10eba7f4c69f4b9"
  end

  resource "isx-vm" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.6.0/isx-vm-macos-aarch64"
    sha256 "0381341694bf62334ececc6e07ca2fca8f4e1e044336ad2c98583e6850241084"
  end

  resource "git-remote-isx" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.6.0/git-remote-isx"
    sha256 "3a0d717f18c6d35fc27266e291e3b91f725cdc17b272db7b2995abe4b72cf4b6"
  end

  resource "completions" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.6.0/completions.tar.gz"
    sha256 "cb7db99c4e08046b2a155c55b036a59cabb2d5e41650ade0d1becd0a1c4e65ba"
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
