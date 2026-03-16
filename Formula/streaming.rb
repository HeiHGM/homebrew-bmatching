class Streaming < Formula
  desc "CLI for running (Semi-)Streaming Hypergraph Matching Algorithms"
  homepage "https://github.com/HeiHGM/Streaming"
  url "https://github.com/HeiHGM/Streaming.git",
      tag:      "v1.0.0",
      revision: "f2c28701c95814620711a76465d57b5139acf6a0"
  license "MIT"
  head "https://github.com/HeiHGM/Streaming.git", branch: "main"
  env :std
  depends_on "bazelisk" => :build

  def install
    # Build the cli target using bazelisk
    system "bazelisk", "build", "-c", "opt", "//app:cli"

    # Copy the binary out of the bazel-bin symlink (which points outside the buildpath)
    system "cp", "-L", "bazel-bin/app/cli", "streaming_cli"

    # Install the compiled binary
    bin.install "streaming_cli"
    pkgshare.install "README.md"
  end

  test do
    # Verify that the cli runs and outputs help
    assert_match "Simpler CLI for running Hypergraph Matching Algorithms.", shell_output("#{bin}/streaming_cli --help")
  end
end