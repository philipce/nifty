# Nifty

[![License](https://img.shields.io/hexpm/l/plug.svg)](LICENSE)

Nifty is a Swift numerical computing library designed to provide a wide range of performant and easy-to-use mathematical tools.

Nifty is really new and (obviously) not complete. The library is constantly expanding—if it doesn't yet have what you need, it will soon! So come back later and check Nifty out when it's a little farther along. Or, [consider contributing](#contributing)!

## Getting Started

##### System Requirements

Currently, Nifty is only being developed on Ubuntu 16.04 (and occasionally built on a Mac) but there's no reason it shouldn't work anywhere Swift does. Future efforts will be made to get Nifty on embedded platforms, like the Raspberry Pi!

_Note to Mac users: The plan is to soon have an Xcode project available so you can skip the rest of the install steps... for now you'll have to roll your own if you want it in Xcode!_

##### Install Swift

Follow these [instructions to install Swift](https://swift.org/getting-started/). Our goal is to stay current as Swift develops, so use the latest release!

Nifty uses the [Swift Package Manager](https://swift.org/package-manager/) (see the [project repo](https://github.com/apple/swift-package-manager) for more info). It greatly simplifies the build process! It comes included with Swift 3.0 and above.

##### Install LAPACK

Nifty uses [LAPACK](http://www.netlib.org/lapack/) for its linear algebra for performance reasons. We'll be using the C interface ([LAPACKE](http://www.netlib.org/lapack/lapacke.html)). 

* Ubuntu: `sudo apt-get install liblapack3 liblapacke liblapacke-dev`

* Mac: `brew install homebrew/dupes/lapack`
   
##### Install OpenBLAS

[BLAS](http://www.netlib.org/blas/) provides lower level functions used by LAPACK (CBLAS provides the C interface). LAPACK comes with a reference implementation of BLAS that is correct but not suitable for high performance applications. You can improve performance by using an optimized implementation instead, like [OpenBLAS](http://www.openblas.net/).

It is strongly recommended that you use OpenBLAS or some other optimized BLAS library; you will see vast performance improvements. For example, using the BLAS reference implementation, Nifty inverts a large matrix in just under 3 minutes on a reference machine, whereas MATLAB does the same in 6.5 seconds. Switching to OpenBLAS, Nifty performs the inversion about as fast as MATLAB does (which is also similar to NumPy, btw).

* Ubuntu: `sudo apt-get install libopenblas-base libopenblas-dev`

* Mac: `brew install homebrew/science/openblas`
   
##### Using Nifty

Once you've installed the above dependencies, using Nifty in your project simply requires that you create/modify your project manifest file to point to this repository as a dependency, and then `import Nifty` in whatever files you want to use it.

Nifty is intended to be simple and easy to use. For this reason, we've decided to structure things similarly to MATLAB. In fact, many (most) of the  function names in Nifty are the same as MATLAB. The hope is that MATLAB users will feel right at home and that users of similar packages (e.g. NumPy) will have an easy transition as well, making adoption as smooth as possible for as many people as possible.

Check out this [Nifty demo project](https://github.com/nifty-swift/Nifty-demo) to see an example of what your project manifest (the file called Package.swift) should look like and how easy it is to use Nifty!

##### Troubleshooting

If you're having troubles, you may find the following helpful:

The system libraries used by Nifty are provided by the [Nifty-libs](https://github.com/nifty-swift/Nifty-libs) package. This is used internally by Nifty so you shouldn't ever need to reference it. One complication that can arise though is if the installed system libraries are in a location not on your linker search path. In that case, you'll need to tell the linker where to find them when you build, e.g. `swift build -Xlinker -L/usr/local/opt/lapack/lib -Xlinker -L/usr/local/opt/openblas/lib`
 
Also, if you decide to use a different system library for one of the system modules (e.g. [ATLAS](http://math-atlas.sourceforge.net/)), you'll need to modify the Nifty-libs module map once the package manager has downloaded the Packages folder.

## Nifty Features

We are currently working on getting the core set of general math and linear algebra functions finished:
- general functions and definitions used throughout Nifty
- matrix definition and linear algebra functionality
- vector and tensor data structures
- wrappers on glibc/math.h
- basic functions related to statistics and probability

See our [status page](Documents/Status.md) for details.

## Tests and Benchmarks

The goal is for Nifty to provide correctness and performance similar to other numerical computing standards. We'll be testing and benchmarking against MATLAB and NumPy.

We will be experimenting with using the [XCTest](https://github.com/apple/swift-corelibs-xctest) framework as it progresses.

## Goals & Scope
The goals of Nifty can be summarized as follows:
- Provide a viable alternative to packages such as NumPy and MATLAB for those who wish to develop in Swift.
- Do as much in Swift as possible, resorting to external C libraries only when necessary for performance reasons.    
- Make exploration of the code as simple as possible, through plain organization and clean, easy-to-read code.
- Serve as a learning opportunity for those wishing to explore numerical computing.

Nifty is intended to be broad in scope; almost any generally interesting tool related to numerical or scientific computing is fair game. A few of the things that Nifty does not *currently* intend to provide are listed below. These items would take a lot of effort to do correctly and would distract from getting the core functionality done, so for the time being, we'd rather defer to other projects.
- Graphical stuff, e.g. matplotlib
- Time series stuff, e.g. pandas
- Modeling and simulation stuff, e.g. simulink

## Contributing

All contributions are welcome—whether suggestions, submissions, requests, or whatever! If you think of a nifty feature we ought to have, let us know. 

To contribute code to this project:

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Check out the documentation for the Nifty style guide
4. Commit your changes: `git commit -am 'Add some feature'`
5. Push to the branch: `git push origin my-new-feature`
6. Submit a pull request!

For anything else, feel free to open an issue!

## Distribution

If you want to statically link Nifty and all its dependencies (e.g. for distribution), an example of how to do that will be forthcoming... For now, [here's a post](http://stackoverflow.com/questions/36570497/compile-c-code-and-expose-it-to-swift-under-linux/) that you may find helpful.

## License

This project is licensed under the Apache License, Version 2.0, a complete copy of which can found in LICENSE, adjacent to this file.