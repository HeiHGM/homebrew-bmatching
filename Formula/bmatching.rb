class Bmatching < Formula
  desc "High-performance solver for b-matching problems in hypergraphs"
  homepage "https://github.com/HeiHGM/Bmatching"
  url "https://github.com/HeiHGM/Bmatching.git",
      tag:      "v1.0.0",
      revision: "HEAD"
  license "MIT"
  head "https://github.com/HeiHGM/Bmatching.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ncurses"

  def install
    system "cmake", "-B", "build",
                    "-DCMAKE_BUILD_TYPE=Release",
                    "-DBUILD_TESTING=OFF",
                    "-DBMATCHING_ENABLE_LOGGING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "-j#{ENV.make_jobs}", "--target", "bmatching_cli"

    bin.install "build/app/bmatching_cli" => "bmatching"
    pkgshare.install Dir["examples/*"]
  end

  test do
    (testpath/"test.hgr").write <<~EOS
      4 4
      1 2
      2 3
      3 4
      1 4
    EOS
    output = shell_output("#{bin}/bmatching --graph #{testpath}/test.hgr --algorithms greedy --capacity 1 --quiet")
    assert_match "weight:", output
  end
end
