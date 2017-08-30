using BinDeps2

# Define what we're downloading, where we're putting it
src_vers = "3.3"
src_url = "https://ftp.gnu.org/gnu/nettle/nettle-$(src_vers).tar.gz"
src_hash = "46942627d5d0ca11720fec18d81fc38f7ef837ea4197c1f630e71ce0d470b11e"

# First, download the source, store it in ./downloads/
src_path = joinpath(pwd(), "downloads", basename(src_url))
try mkpath(dirname(src_path)) end
download_verify(src_url, src_hash, src_path; verbose=true)

# Our build products will go into ./products
out_path = joinpath(pwd(), "products")
try mkpath(out_path) end

# Build Nettle for all our platforms
for platform in supported_platforms()
    target = platform_triplet(platform)

    # We build in a platform-specific directory
    build_path = joinpath(pwd(), "build", target)
    try mkpath(build_path) end

    cd(build_path) do
        # For each build, create a temporary prefix we'll install into, then package up
        temp_prefix() do prefix
            # Unpack the source into our build directory
            unpack(src_path, build_path; verbose=true)

            # We expect these outputs from our build steps
            libnettle = LibraryResult(joinpath(libdir(prefix), "libnettle"))
            nettlehash = FileResult(joinpath(bindir(prefix), "nettle-hash"))

            # We build using the typical autoconf incantation
            steps = [
                # We pass `--host=$(target)` to tell configure we want to cross-compile
                # We pass `--prefix=/` because BinDeps2 has already set the `$DESTDIR`
                # environment variable, so we don't need to tell configure where to install
                `./nettle-$(src_vers)/configure --host=$(target) --prefix=/`,
                `make -j3`,
                `make install`
            ]

            dep = Dependency("nettle", [libnettle, nettlehash], steps, platform, prefix)
            build(dep; verbose=true)

            # Once we're built up, go ahead and package this prefix out
            package(prefix, joinpath(out_path, "nettle"); platform=platform, verbose=true)
        end
    end
    
    # Finally, destroy the build_path
    rm(build_path; recursive=true)
end
