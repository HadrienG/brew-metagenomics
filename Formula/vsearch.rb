class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"

  url "https://github.com/torognes/vsearch/archive/v2.4.4.tar.gz"
  sha256 "13909f188d0e0ddb24a845e3d8d60afe965751e800659ae729bb61c5e5230ab5"
  head "https://github.com/torognes/vsearch.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
  end

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"fileA").write <<-EOS.undent
    >1
    AGATGTGCTG
    >2
    AGATGTGCTG
    EOS
    (testpath/"test_output").write <<-EOS.undent
    1	2	100.0	10	0	0	1	10	1	10	-1	0
    EOS
    system "#{bin}/vsearch",
      "--allpairs_global fileA --id 0.5 --blast6out out_file"
    assert_predicate testpath/"out_file", :exist?
    assert_match(File.read("out_file"), File.read("test_output"))
  end
end
