using BinaryBuilder
using SHA

# Define what we're downloading, where we're putting it
src_name = "nettle"
src_vers = "3.3"
src_url = "https://ftp.gnu.org/gnu/nettle/nettle-$(src_vers).tar.gz"
src_hash = "46942627d5d0ca11720fec18d81fc38f7ef837ea4197c1f630e71ce0d470b11e"

# First, download the source, store it in ./downloads/
src_path = joinpath(pwd(), "downloads", basename(src_url))
try mkpath(dirname(src_path)) end
download_verify(src_url, src_hash, src_path; verbose=true)

# Our build products will go into ./products
out_path = joinpath(pwd(), "products")
rm(out_path; force=true, recursive=true)
mkpath(out_path)

# Build for all our platforms
products = Dict()
for platform in supported_platforms()
    target = triplet(platform)

    # We build in a platform-specific directory
    build_path = joinpath(pwd(), "build", target)
    try mkpath(build_path) end

    cd(build_path) do
        # For each build, create a temporary prefix we'll install into, then package up
        temp_prefix() do prefix
            # Unpack the source into our build directory
            unpack(src_path, build_path; verbose=true)

            # We expect these outputs from our build steps
            libnettle = LibraryProduct(prefix, "libnettle")
            nettlehash = ExecutableProduct(prefix, "nettle-hash")

            # We build using the typical autoconf incantation
            steps = [
                # We pass `--host=$(target)` to tell configure we want to cross-compile
                # We pass `--prefix=/` because BinDeps2 has already set the `$DESTDIR`
                # environment variable, so we don't need to tell configure where to install
                `./$(src_name)-$(src_vers)/configure --host=$(target) --prefix=/`,
                `make clean`,
                `make -j$(min(Sys.CPU_CORES + 1,8))`,
                `make install`
            ]

            dep = Dependency(src_name, [libnettle, nettlehash], steps, platform, prefix)
            build(dep; verbose=true, autofix=true)

            # Once we're built up, go ahead and package this prefix out
            tarball_path, tarball_hash = package(prefix, joinpath(out_path, src_name); platform=platform, verbose=true)
            products[target] = (basename(tarball_path), tarball_hash)
        end
    end
    
    # Finally, destroy the build_path
    rm(build_path; recursive=true)
end

# In the end, dump an informative message telling the user how to download/install these
info("Hash/filename pairings:")
for target in keys(products)
    filename, hash = products[target]
    println("    $(platform_key(target)) => (\"\$bin_prefix/$(filename)\", \"$(hash)\"),")
end
