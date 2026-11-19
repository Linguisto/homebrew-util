# Homebrew utilities tap

Packages for macOS:

- `free`: Linux-like memory and swap summary.
- `ramdisk`: `ramdisk`, `ramstage`, and `ramunstage` commands.

The `ramdisk` package provides RAM disks and compressed image staging. The formula declares Homebrew `xz` and `zstd` dependencies and uses
macOS-provided Bash, gzip, bzip2, and disk management tools.
The `ramdisk` package requires macOS 13 Ventura or later.

## Install

```sh
brew install Linguisto/util/free
brew install Linguisto/util/ramdisk
```

## Update and remove

```sh
brew update
brew upgrade free ramdisk
brew uninstall ramdisk
```

## Maintainer release procedure

1. Update and tag the source in `Linguisto/ramdisk-macos`.
2. Create a release archive containing the executable scripts and their documentation.
3. Upload the archive as a GitHub release asset.
4. Update `Formula/ramdisk.rb` with the asset URL and its SHA-256.
5. Test the formula, then push this tap.

The release asset checksum must match the formula. A GitHub automatically
created source archive has a different checksum from a separately uploaded asset.

For later updates, change the version strings in both scripts, create a new
release archive, calculate `shasum -a 256 <archive>`, and update the formula's
versioned URL, checksum and version assertion. Publish the release asset before
the corresponding formula update. Installed users then use `brew upgrade`.

The source and release carry the MIT license, matching the author's existing
`free-macos` project.
