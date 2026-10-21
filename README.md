# Sanne's Homebrew Tap

Personal Homebrew tap for macOS tools.

## Available Formulas

### incus-spawn

CLI tool for managing isolated Incus-based development environments.

**Installation:**

```bash
brew tap Sanne/tap
brew install incus-spawn
```

Or in one command:

```bash
brew install Sanne/tap/incus-spawn
```

**Requirements:**
- Apple Silicon (arm64) Mac; Intel (x86_64) Macs get a binary too, as best effort: it is
  built and released on the same minimum but not verified on an Intel Mac
- macOS 15 (Sequoia) or later: the release binaries are built for macOS 15 and checked for it
  before release, and the formula declares `depends_on macos: :sequoia`, so `brew install`
  refuses older versions

**Documentation:** https://github.com/Sanne/incus-spawn

---

## Maintaining This Tap

### Adding a New Formula

1. Create `Formula/<tool-name>.rb`
2. Test: `brew install --build-from-source Formula/<tool-name>.rb`
3. Commit and push

### Updating incus-spawn

The incus-spawn release workflow updates `Formula/incus-spawn.rb` (and `incus-spawn-dev.rb` for
`-dev` tags) automatically, including the `depends_on macos:` minimum; see
[docs/HOMEBREW.md](https://github.com/Sanne/incus-spawn/blob/main/docs/HOMEBREW.md). If that step
fails, update the formula by hand after the release, keeping the `depends_on macos:` line:

1. **Update version** in `Formula/incus-spawn.rb`

2. **Compute SHA256 hashes**:
   ```bash
   VERSION=0.1.28
   curl -sL https://github.com/Sanne/incus-spawn/releases/download/v${VERSION}/incus-spawn-macos-aarch64 | shasum -a 256
   curl -sL https://github.com/Sanne/incus-spawn/releases/download/v${VERSION}/git-remote-isx | shasum -a 256
   ```

3. **Update SHA256 values** in the formula

4. **Test locally**:
   ```bash
   brew install --build-from-source Formula/incus-spawn.rb
   isx --version
   brew uninstall incus-spawn
   ```

5. **Commit and push**:
   ```bash
   git add Formula/incus-spawn.rb
   git commit -m "incus-spawn: update to v${VERSION}"
   git push
   ```

Users will get the update on their next `brew update && brew upgrade`.
