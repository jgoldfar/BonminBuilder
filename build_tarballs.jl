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
cd $WORKSPACE/srcdir/nettle-3.3/
./configure --prefix=/ --host=$target
make -j3
make install
"""

products = prefix -> [
  LibraryProduct(prefix,"libnettle"),
  ExecutableProduct(prefix,"nettle-hash")
]

# Choose which platforms to build for; if we've got an argument use that one,
# otherwise default to just building all of them!
build_platforms = platforms
if length(ARGS) > 0
    build_platforms = platform_key.(split(ARGS[1], ","))
end
info("Building for $(join(triplet.(build_platforms), ", "))")

autobuild(pwd(), "nettle", build_platforms, sources, script, products)
