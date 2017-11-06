using BinaryBuilder

platforms = [
  BinaryProvider.Windows(:i686),
  BinaryProvider.Windows(:x86_64),
  BinaryProvider.Linux(:i686, :glibc),
  BinaryProvider.Linux(:x86_64, :glibc),
  BinaryProvider.Linux(:aarch64, :glibc),
  BinaryProvider.Linux(:armv7l, :glibc),
  BinaryProvider.Linux(:powerpc64le, :glibc),
  BinaryProvider.MacOS()
]

sources = [
  "https://ftp.gnu.org/gnu/nettle/nettle-3.3.tar.gz" =>
  "46942627d5d0ca11720fec18d81fc38f7ef837ea4197c1f630e71ce0d470b11e",
]

script = raw"""
cd $WORKSPACE/srcdir
cd nettle-3.3/
./configure --prefix=/ --host=$target
make install -j3

"""

products = prefix -> [
  LibraryProduct(prefix,"libnettle"),
  ExecutableProduct(prefix,"nettle-hash")
]

autobuild(pwd(), "nettle", platforms, sources, script, products)
