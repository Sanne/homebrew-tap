class IncusSpawn < Formula
  desc "CLI tool for managing isolated Incus-based development environments"
  homepage "https://github.com/Sanne/incus-spawn"
  version "0.4.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-aarch64"
      sha256 "dfe17042de169bb214e894f3992c80c978c10290f2d54b6f552861089e6e203a"
    else
      url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-x86_64"
      sha256 "b0517afcbaf116e32a031374479dcb92b413787f61a229c7baeef40b97614730"
    end
  end

  depends_on macos: :sequoia
  depends_on "vfkit"

  resource "isx-proxy" do
    on_macos do
      on_arm do
        url "https://github.com/Sanne/incus-spawn/releases/download/v0.4.0/isx-proxy-macos-aarch64"
        sha256 "0756270bf1b51a30616b8c5b4ddc6dcd4d3133e5fc7cec47acf4dd6286f7fbb2"
      end
      on_intel do
        url "https://github.com/Sanne/incus-spawn/releases/download/v0.4.0/isx-proxy-macos-x86_64"
        sha256 "173c8104e247c1dda4cbdfb2c1b7a794d8fa09219e4cf57737bacbffe645c68f"
      end
    end
  end

  resource "git-remote-isx" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.4.0/git-remote-isx"
    sha256 "23dce674bcceed571f2c7760143d8bbf08aae1f903c3cf398f5256b0bf1cfa10"
  end

  resource "completions" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.4.0/completions.tar.gz"
    sha256 "1d62e959b094738eb59cf8d0d38b074309d7ef0edda4a06f14e8cb1c6a807285"
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
