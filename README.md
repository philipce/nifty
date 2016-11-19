# Nifty

[![License](https://img.shields.io/hexpm/l/plug.svg)](LICENSE)

*Note: Nifty is currently undergoing transition to use the swift package manager!
It is also undergoing upgrades to 3.0.1. As such, for the next few weeks, the info
below may not be current and a lot of the files may be missing. This will be fixed 
shortly!*

Nifty is a Swift numerical computing library designed to provide common 
mathematical functions in a performant and easy-to-use way.

Nifty is really new and (obviously) incomplete. The content here is the 
beginnings of the framework but not yet ready for consumption. Come back 
and check Nifty out later when it's a little farther along. Or, consider
contributing! 



## Goals and Scope

_TODO: flesh out this section_

Goals:
- Provide a robust, performant numerical computing package suitable for 
    industrial or research purposes 
- Do it in a way that will be familiar to those with experience in other such 
    environments and will also easy to learn for the first-timer 
- Do as much in Swift as possible, resorting to C libraries only when needed
    for performance reasons
- Make exploration of the code as simple as possible, through straight-forward
    organization and clean, well-commented, easy-to-read code
- Serve as a place to put the nifty bits of code that always seem to accumulate
- Serve as a learning tool for those wishing to explore numerical computing

Scope:
- graphical stuff, e.g. matplotlib, not currently in scope. Perhaps in future,
    but we'd rather defer to another project on that



## Getting Started

#### System Requirements

Make sure you can [install Swift](https://swift.org/getting-started/).
Our goal is to stay current as Swift develops, so use the latest release!

Currently, Nifty is only being developed on Ubuntu 16.04, but there's no reason
it shouldn't work anywhere Swift does. Future efforts will be made to bring 
Nifty to Mac and RaspberryPi!

#### Installation

Nifty uses the [Swift Package Manager](https://swift.org/package-manager/) 
(see the [project repo](https://github.com/apple/swift-package-manager) for more 
info). It greatly simplifies the build process!

To use Nifty in your projects:
- Make sure you have the needed [dependencies](#dependencies) installed
- Create/modify your project manifest file to include Nifty (here's a 
[complete example](https://github.com/nifty-swift/Nifty-demo))
- Let the package manager do the rest! It's that easy!

#### Usage

Nifty is intended to be simple and easy to use. For this reason, we've decided
to structure things similar to how MATLAB works. In fact, many (most) of the 
function names in Nifty are the same as MATLAB. The hope is that MATLAB users
will feel right at home and that users of similar packages (e.g. NumPy) will 
have an easy transition as well, making adoption as smooth as possible for as 
many people as possible.

Check out the [demo](https://github.com/nifty-swift/Nifty-demo) to see Nifty 
in action!

#### Dependencies

_TODO: This is pretty incomplete now but it'll get better!_

Besides having Swift installed, there are a few things you'll need to run Nifty:
- Swift Package Manager: this is included with Swift 3.0 and above. If you 
    somehow didn't get or need to update, go 
    [here](https://swift.org/package-manager/)
- LAPACK: Nifty uses [LAPACK](http://www.netlib.org/lapack/) for its 
    linear algebra, mostly for performance reasons. We'll be using the C 
    interface ([LAPACKE](http://www.netlib.org/lapack/lapacke.html)). 
 - Ubuntu: `sudo apt-get install liblapack3 liblapacke liblapacke-dev`
- BLAS: BLAS(http://www.netlib.org/blas/) provides lower level functions 
    used by LAPACK. LAPACK comes with a reference version that is correct, 
    but not suitable for high performance applications. You can improve 
    performance by using an optimized implementation instead 
    (e.g. [OpenBLAS](http://www.openblas.net/)). For example, using the BLAS 
    reference implementation, Nifty inverts a large matrix in just under 3 
    minutes whereas MATLAB inverts it in 6.5 seconds. Switching to OpenBLAS, 
    Nifty performs the inversion about as fast as MATLAB does. If you do
    switch to OpenBLAS, you'll also need to ensure pthreads is installed.
- Fortran: LAPACK needs fortran installed.
 - Ubuntu: `sudo apt-get install gfortran`



## Tests and Benchmarks

The goal is for Nifty to provide correctness and performance similar to other 
numerical computing standards. We'll be testing and benchmarking against
MATLAB and NumPy.

We will be experimenting with using the 
[XCTest](https://github.com/apple/swift-corelibs-xctest) framework as it 
progresses.



## Contributing

All contributions are welcome! If you think of a nifty feature we ought to 
have, let us know. 

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Check out the documentation for the Nifty style guide
4. Commit your changes: `git commit -am 'Add some feature'`
5. Push to the branch: `git push origin my-new-feature`
6. Submit a pull request :D



## Repository Overview

_TODO: update this for swift package manager!_



## Nifty Features

We are currently working on getting the core set of general math and linear algebra
functions finished:
- general functions and definitions used throughout Nifty
- matrix definition and linear algebra functionality
- vector and tensor data structures
- wrappers on glibc/math.h
- basic functions related to statistics and probability

See our [status page](Documents/Status.md) for details.



## Distribution

_TODO: If you want to link statically e.g. for distribution, here's an 
example of how to..._



## License

This project is licensed under the Apache License, Version 2.0, a complete copy of 
which can found in LICENSE, adjacent to this file.