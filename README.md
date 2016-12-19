# Nifty

[![License](https://img.shields.io/hexpm/l/plug.svg)](LICENSE)

Nifty is a Swift numerical computing library designed to provide common 
mathematical functions in a performant and easy-to-use way.

Nifty is really new and (obviously) not complete. The library is constantly 
expanding--if it doesn't yet have what you need, it will soon! So come back 
later and check Nifty out when it's a little farther along. Or, consider 
contributing! Suggestions, submissions, and requests are welcome.

## Getting Started

##### System Requirements

Currently, Nifty is only being developed on Ubuntu 16.04 (and occasionally 
built on a Mac) but there's no reason it shouldn't work anywhere Swift does.
Future efforts will be made to get Nifty on embedded platforms, like the 
Raspberry Pi!

##### Install Swift

Follow these [instructions to install Swift](https://swift.org/getting-started/).
Our goal is to stay current as Swift develops, so use the latest release!

Nifty uses the [Swift Package Manager](https://swift.org/package-manager/) 
(see the [project repo](https://github.com/apple/swift-package-manager) for more 
info). It greatly simplifies the build process! It comes included with Swift 3.0
and above.

##### Install LAPACK

Nifty uses [LAPACK](http://www.netlib.org/lapack/) for its linear algebra  
(mostly for performance reasons). We'll be using the C interface 
([LAPACKE](http://www.netlib.org/lapack/lapacke.html)). LAPACK needs Fortran,
so if it's not already on your computer, you may need to install that too.

* Ubuntu:
`sudo apt-get install gfortran liblapack3 liblapacke liblapacke-dev`

* Mac:
`brew install homebrew/dupes/lapack`

##### Install OpenBLAS

BLAS [BLAS](http://www.netlib.org/blas/) provides lower level functions 
used by LAPACK (CBLAS provides the C interface). LAPACK comes with a 
reference implementation of BLAS that is correct but not suitable for high 
performance applications. You can improve performance by using an optimized
implementation instead, like [OpenBLAS](http://www.openblas.net/)).

It is strongly recommended that you use OpenBLAS or some other optimized 
BLAS library; you will see vast performance improvements. For example, 
using the BLAS reference implementation, Nifty inverts a large matrix in just 
under 3 minutes on a reference machine, whereas MATLAB does it in 6.5 seconds. 
Switching to OpenBLAS, Nifty performs the inversion about as fast as MATLAB 
does (which is also similar to NumPy).

* Ubuntu: `sudo apt-get install libopenblas-base libopenblas-dev`

   _(switch between the different installed BLAS options using: 
   `sudo update-alternatives --config libblas.so`)_

* Mac: `brew install homebrew/science/openblas`

   _(LAPACK comes already installed in the Accelerate framework, so you
   could just use that instead)_

##### Import Nifty

Once you've installed the above dependencies, using Nifty in your project
simply requires that you create/modify your project manifest file to 
point to the Nifty repository as a dependency, and then `import Nifty` in
whatever files you want to use it! Check out this  
[complete example](https://github.com/nifty-swift/Nifty-demo) to see just
how easy the Swift Package Manager makes your life.

##### Using Nifty

Nifty is intended to be simple and easy to use. For this reason, we've decided
to structure things similar to how MATLAB works. In fact, many (most) of the 
function names in Nifty are the same as MATLAB. The hope is that MATLAB users
will feel right at home and that users of similar packages (e.g. NumPy) will 
have an easy transition as well, making adoption as smooth as possible for as 
many people as possible.

Check out the [demo](https://github.com/nifty-swift/Nifty-demo) to see Nifty 
in action!

##### Adapting System Paths

_Note: The system modules used by Nifty (e.g. 
[CLapacke](https://github.com/nifty-swift/CLapacke), 
[CBlas](https://github.com/nifty-swift/CBlas)), have hard coded paths to
the required headers (they expect to find them in /usr/include) If your
package manager installs things differently, you'll have to change the 
paths in the module map._

Or you can install a dupe with brew, `brew install homebrew/dupes/lapack` 
then change the module map in CLapacke package to wherever it put the 
headers, e.g. /usr/local/opt/lapack/include. BLAS is also in Accelerate,
or you can install OpenBLAS with `brew install homebrew/science/openblas`
then modify the CBlas package module map to installed location,
e.g. /usr/local/opt/openblas/include. Also, it looks like OpenBLAS includes
LAPACK (not sure if it includes it all) so you may just need that.
If you manually installed the libraries, then you need to tell `swift build`
where to look. The only way I got it to work was manually passing flags to 
the linker, e.g. `swift build -Xlinker -L/usr/local/opt/lapack/lib -Xlinker -L/usr/local/opt/openblas/lib`.
Also, I had to modify the CBlas module map to link "openblas" rather than "blas"
otherwise it would find its preinstalled library that didn't have the CBLAS symbols; 
openblas does._

## Tests and Benchmarks

The goal is for Nifty to provide correctness and performance similar to other 
numerical computing standards. We'll be testing and benchmarking against
MATLAB and NumPy.

We will be experimenting with using the 
[XCTest](https://github.com/apple/swift-corelibs-xctest) framework as it 
progresses.

## Goals & Scope
The goals of Nifty can be summarized as follows:
- Provide a viable alternative to packages such as NumPy and MATLAB for those
    who wish to develop in Swift.
- Do as much in Swift as possible, resorting to external C libraries only when
    necessary for performance reasons.    
- Make exploration of the code as simple as possible, through plain 
    organization and clean, easy-to-read code.
- Serve as a learning opportunity for those wishing to explore numerical 
    computing.

Nifty is intended to be broad in scope; almost any generally interesting tool
related to numerical or scientific computing is fair game. A few of the things
that Nifty does not *currently* intend to provide are listed below. These items
would take a lot of effort to do correctly and would distract from getting the 
core functionality done, so for the time being, we'd rather defer to other 
projects.
- Graphical stuff, e.g. matplotlib
- Time series stuff, e.g. pandas
- Modeling and simulation stuff, e.g. simulink

## Contributing

All contributions are welcome! If you think of a nifty feature we ought to 
have, let us know. 

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Check out the documentation for the Nifty style guide
4. Commit your changes: `git commit -am 'Add some feature'`
5. Push to the branch: `git push origin my-new-feature`
6. Submit a pull request :D

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
