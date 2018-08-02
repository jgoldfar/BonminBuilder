using BinaryBuilder

# Collection of sources required to build Bonmin and Couenne
name = "Bonmin-Couenne"
version = v"0.0"
sources = [
    "https://github.com/coin-or/Couenne/archive/releases/0.5.6.tar.gz" =>
    "",
    
    "https://github.com/coin-or/Bonmin/archive/releases/1.8.6.tar.gz" =>
    ""
]

# Bash recipe for building across all platforms
script = raw"""
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
    ExecutableProduct(prefix, "couenne", :couenne),
    ExecutableProduct(prefix, "bonmin", :bonmin)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
