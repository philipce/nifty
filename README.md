[![status](https://travis-ci.org/nifty-swift/Nifty.svg?branch=master)](https://travis-ci.org/nifty-swift/Nifty)
[![codecov](https://codecov.io/gh/nifty-swift/Nifty/branch/master/graph/badge.svg)](https://codecov.io/gh/nifty-swift/Nifty)
![plaforms](https://img.shields.io/badge/platforms-Linux%20%7C%20macOS-lightgrey.svg)
![swift](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)
![license](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)

# Nifty

[Nifty](https://github.com/nifty-swift/Nifty) is a general-purpose numerical computing library for the Swift programming language, made with performance and ease-of-use in mind. 

## Getting Started

Not sure if Nifty is what you're looking for? Check out a [simple demo project](https://github.com/nifty-swift/Nifty-demo) or peruse the [documentation](http://nifty-swift.org) to help you decide.

Nifty is being developed on Ubuntu 14.04/16.04 and on macOS Sierra. Our goal is to stay current as Swift develops, so make sure to [install the latest release](https://swift.org/getting-started/).

### Installation

There are a number of options when it comes to getting up and running with Nifty. In order of easiness:
- Pull down the [Docker image](https://hub.docker.com/r/niftyswift/nifty/)
- Use the included project file in Xcode
- Install with the Swift Package Manager

##### Docker

The `niftyswift/nifty` repo on Docker Hub comes with Swift and all the libraries installed! It even has a base project already set up, so you can just start writing Nifty code.

If you don't have Docker set up already, go [here](https://docs.docker.com/engine/installation/).

Once Docker is set up, the remaining steps are easy:
- Pull down the image and start the container: `docker run -it niftyswift/nifty` – this will start a shell inside the container, within a preconfigured project folder
- Write your code (e.g. `vi main.swift`)
- Run `swift build` – this will pull down the Nifty library code
- Execute your program with `.build/debug/myapp`

If you've already got a project on your host machine, you can mount it when you start the container and edit locally, e.g. `docker run -v /home/myapp:/myapp -it niftyswift/nifty`

##### Xcode

Xcode users can just use the included project file. Simply drag the project file into your own Xcode project, add Nifty to your target's dependencies, and `import Nifty` at the top of any files in which you wish to use Nifty!

Nifty uses [BLAS](http://www.netlib.org/blas/) and [LAPACK](http://www.netlib.org/lapack/). When built with Xcode, these are provided by the [Accelerate](https://developer.apple.com/reference/accelerate) framework. Since Accelerate is installed on macOS by default, no additional installation steps are needed.

##### Swift Package Manager

Linux users (and those on macOS who prefer not to use Xcode) can install Nifty using the [Swift Package Manager](https://swift.org/package-manager/).

Nifty uses [BLAS](http://www.netlib.org/blas/) and [LAPACK](http://www.netlib.org/lapack/). When built with the Swift Package Manager, Nifty uses the C interface [LAPACKE](http://www.netlib.org/lapack/lapacke.html) and the optimized library [OpenBLAS](http://www.openblas.net/). These can be installed with the following commands:
- Ubuntu: `sudo apt-get install liblapack3 liblapacke liblapacke-dev libopenblas-base libopenblas-dev`
- Mac: `brew install homebrew/dupes/lapack homebrew/science/openblas`

Once the dependencies are installed, using Nifty in your project simply requires that you create/modify your project manifest file to point to this repository as a dependency, and then `import Nifty` in whatever files you want to use it. Your project can then be built by simply running `swift build`. 

Refer to the aforementioned [demo project](https://github.com/nifty-swift/Nifty-demo) to see an example of what your project manifest (the file called Package.swift) should look like and how easy it is to use Nifty!

### Usage

Nifty is intended to be simple and easy to use. For this reason, we've decided to structure things similarly to MATLAB. In fact, many of the function names in Nifty are the same as MATLAB. The hope is that MATLAB users will feel right at home and that users of similar packages (e.g. NumPy) will have an easy transition as well, making adoption as smooth as possible for as many people as possible. Check out the [API](http://nifty-swift.org)!

### Troubleshooting

If you're having troubles, you may find the following helpful:

The system libraries used by Nifty are provided by the [Nifty-libs](https://github.com/nifty-swift/Nifty-libs) package. This is used internally by Nifty so you shouldn't ever need to reference it. One complication that can arise though is if the installed system libraries are in a location not on your linker search path. In that case, you'll need to tell the linker where to find them when you build, e.g. `swift build -Xlinker -L/usr/local/opt/lapack/lib -Xlinker -L/usr/local/opt/openblas/lib`
 
If you decide to use a different system library for one of the required system modules, you'll need to modify the Nifty-libs module map once the package manager has downloaded the Packages folder.

If you're building with Xcode, you need to compile with `-DNIFTY_XCODE_BUILD`. Nifty uses different modules for Xcode builds and Swift Package Manager builds. The included project has this defined already, but if you build your own project, you'll need to do this (in the project settings -> "Build Settings", search for "Swift flags").

 Some users have had problems with the included Xcode project giving the errors: "Undefined OBJROOT" or "Undefined SYMROOT". One possible fix: From the project navigation side bar, click on the project icon to bring up the project settings. SYMROOT (aka  Build Products Path) and OBJROOT (aka Intermediate Build Files Path) can be set in the Build Settings tab. From the Build Settings tab, search for SYMROOT or OBJROOT. It should bring up Build Products Path or Intermediate Build Files Path (if not, make sure the search bar is set to search "All", not just "Basic"). From there, you can set the paths as you wish (a reasonable default is $SRCROOT/build). For more info, see Apple's Xcode Build System Guide - Build Setting Reference.  

## Nifty Features

Nifty is really new and (obviously) not complete. The library is constantly expanding—if it doesn't yet have what you need, it will soon! Either come back later and check Nifty out when it's a little farther along, or, [consider contributing](#contributing)!

We are currently working on getting the core set of general math and linear algebra functions finished:
- general functions and definitions used throughout Nifty
- matrix definition and linear algebra functionality
- vector and tensor data structures
- wrappers on glibc/math.h
- basic functions related to statistics and probability

See our [status page](Documents/Status.md) for details on the implementation status of all features, as well as plans for the future.

## Tests and Benchmarks

Nifty uses the [XCTest](https://github.com/apple/swift-corelibs-xctest) framework to manage unit tests. Tests can be run directly from Xcode or, if not using Xcode, by executing `swift test` in the repository root directory.

The goal is for Nifty to provide correctness and performance similar to other numerical computing standards. We'll be testing and benchmarking mainly against MATLAB and NumPy. Check out the [status page](Documents/Status.md) to see where the test coverage is currently at.

You can check out the results of some simple benchmarks [here](https://github.com/nifty-swift/Nifty/blob/master/Documents/Benchmarks.md).

## Goals & Scope
The goals of Nifty can be summarized as follows:
- Provide a viable alternative to packages such as NumPy and MATLAB for those who wish to develop in Swift, whether on macOS or Linux.
- Develop fun and interesting code and algorithms.
- Do as much in Swift as feasible.
- Make exploration of the code as simple as possible.
- Serve as a learning opportunity for those wishing to explore numerical computing.

Nifty is intended to be broad in scope; almost any generally interesting/useful tool related to numerical or scientific computing, data structures, algorithms, etc. is fair game. However, we will prioritize the core functionality as outlined on the [status page](Documents/Status.md).

## Contributing

All contributions are welcome—-whether suggestions, submissions, requests, or whatever! If you think of a nifty feature we ought to have, let us know. If you'd like to contribute, but aren't sure exactly what, visit the [status page](Documents/Status.md) for ideas--a lot of things that wouldn't require a great deal of time or expertise remain unimplemented or untested!

To contribute code to this project:

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Check out the [style guide](https://github.com/nifty-swift/Nifty/blob/master/Documents/Style.md)
4. Consider including a test, even if it's super basic
5. Commit your changes: `git commit -am 'Add some feature'`
6. Push to the branch: `git push origin my-new-feature`
7. Submit a pull request!

For anything else, feel free to open an issue!

We're also on Slack. If you want to join the conversation, let us know.

## License

This project is licensed under the Apache License, Version 2.0, a complete copy of which can found in LICENSE, adjacent to this file.
