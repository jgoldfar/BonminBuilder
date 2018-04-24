using BinaryBuilder

# Collection of sources required to build Nettle
sources = [
  "https://ftp.gnu.org/gnu/nettle/nettle-3.4.tar.gz" =>
  "ae7a42df026550b85daca8389b6a60ba6313b0567f374392e54918588a411e94",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/nettle-3.4/
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
  Windows(:i686),
  Windows(:x86_64),
  Linux(:i686, :glibc),
  Linux(:x86_64, :glibc),
  Linux(:aarch64, :glibc),
  Linux(:armv7l, :glibc),
  Linux(:powerpc64le, :glibc),
  MacOS(),
  FreeBSD(:x86_64),
]

# The products that we will ensure are always built
products(prefix) = [
  LibraryProduct(prefix, "libnettle", :libnettle),
  ExecutableProduct(prefix, "nettle-hash", :nettle_hash)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "Nettle", sources, script, platforms, products, dependencies)
