# BonminBuilder

[![Build Status](https://travis-ci.org/jgoldfar/BonminBuilder.svg?branch=master)](https://travis-ci.org/jgoldfar/BonminBuilder)

This is an example repository showing how to construct a "builder" repository for a binary dependency.  Using a combination of [`BinaryBuilder.jl`](https://github.com/staticfloat/BinaryBuilder.jl), [Travis](https://travis-ci.org), and [GitHub releases](https://docs.travis-ci.com/user/deployment/releases/), we are able to create a fully-automated, github-hosted binary building and serving infrastructure.

## Troubleshooting/Developing ##

Since the images are built on Travis-CI using Julia v0.6 and a Linux image, the same environment should be set-up locally to develop and troubleshoot the builders. Below are the steps I followed to set up a development environment on my Mac, from [the Travis docs](https://docs.travis-ci.com/user/common-build-problems/#troubleshooting-locally-in-a-docker-image) and with inspiration from the [IpoptBuilder](https://github.com/staticfloat/IpoptBuilder/blob/master/build_tarballs.jl)  [NettleBuilder](https://github.com/staticfloat/NettleBuilder).

We will be building

    https://github.com/coin-or/Bonmin/archive/releases/1.8.6.tar.gz

With docker installed, start a container:

    docker run --name travis-debug -dit travisci/ci-garnet:packer-1512502276-986baf0 /sbin/init

Open a login shell

    docker exec -it travis-debug bash -l

Switch to user `travis`

    su - travis

Follow the rest of the directions for running BinaryBuilder/building on Travis:

    git clone --depth=99999999 --branch=master https://github.com/jgoldfar/BonminBuilder.git jgoldfar/BonminBuilder
    cd jgoldfar/BonminBuilder/
    export BINARYBUILDER_DOWNLOADS_CACHE=downloads
    export BINARYBUILDER_AUTOMATIC_APPLE=true
    export JULIA_PROJECT=@.
    CURL_USER_AGENT="Travis-CI $(curl --version | head -n 1)"
    mkdir -p ~/julia
    curl -A "$CURL_USER_AGENT" -s -L --retry 7 'https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6-latest-linux-x86_64.tar.gz' | tar -C ~/julia -x -z --strip-components=1 -f -
    export PATH="${PATH}:${HOME}/julia/bin"
    julia -e 'versioninfo()'
    julia -e 'Pkg.clone("https://github.com/JuliaPackaging/BinaryProvider.jl")'
    julia -e 'Pkg.clone("https://github.com/JuliaPackaging/BinaryBuilder.jl"); Pkg.build()'

    
Other references: 

* https://github.com/coin-or-tools/BuildTools

* https://github.com/coin-or/Bonmin

* https://www.coin-or.org/download/source/Clp/

* https://hub.docker.com/r/staticfloat/binarybuilder.jl/