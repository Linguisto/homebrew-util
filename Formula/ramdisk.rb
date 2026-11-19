class Ramdisk < Formula
  desc "Create RAM disks and decompress images directly into memory on macOS"
  homepage "https://github.com/Linguisto/ramdisk-macos"
  url "https://github.com/Linguisto/ramdisk-macos/releases/download/v0.1.0/ramdisk-macos-0.1.0.tar.gz"
  sha256 "63c86e6c3f0edec310c4c8681c6643952ddcd67500ec0b3b893aef0184af671e"
  license "MIT"

  depends_on macos: :ventura
  depends_on "xz"
  depends_on "zstd"

  def install
    # Use the declared Homebrew decompressors even with a minimal user PATH.
    inreplace ["ramdisk", "ramstage"], "set -euo pipefail",
      "set -euo pipefail\nexport PATH=\"#{Formula["xz"].opt_bin}:#{Formula["zstd"].opt_bin}:/usr/bin:/bin:/usr/sbin:/sbin:$PATH\""
    bin.install "ramdisk", "ramstage"
    bin.install_symlink bin/"ramstage" => "ramunstage"
  end

  test do
    assert_match "ramdisk 0.1.0", shell_output("#{bin}/ramdisk --version")
    assert_match "--size", shell_output("#{bin}/ramstage --help")
    assert_match "ramunstage", shell_output("#{bin}/ramunstage --help")
    (testpath/"plain.img").write "This is not a compressed image."
    output = shell_output("#{bin}/ramstage #{testpath}/plain.img 2>&1", 1)
    assert_match "Unsupported compression", output
    # Gzip input without --size must fail before allocating a RAM disk.
    system "/usr/bin/gzip", "-k", testpath/"plain.img"
    output = shell_output("#{bin}/ramstage #{testpath}/plain.img.gz 2>&1", 1)
    assert_match "--size is required", output
  end
end
