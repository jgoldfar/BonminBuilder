# BonminBuilder

[![Build Status](https://travis-ci.org/jgoldfar/BonminBuilder.svg?branch=master)](https://travis-ci.org/jgoldfar/BonminBuilder)

This is an example repository showing how to construct a "builder" repository for a binary dependency.  Using a combination of [`BinaryBuilder.jl`](https://github.com/staticfloat/BinaryBuilder.jl), [Travis](https://travis-ci.org), and [GitHub releases](https://docs.travis-ci.com/user/deployment/releases/), we are able to create a fully-automated, github-hosted binary building and serving infrastructure.

We will be building binaries for

    https://www.coin-or.org/download/source/Bonmin/Bonmin-1.8.6.tgz
