# Nifty

[![License](https://img.shields.io/hexpm/l/plug.svg)](LICENSE)

*Note: Nifty is currently undergoing transition to use the swift package manager!
It is also undergoing upgrades to 3.0.1. As such, for the next few weeks, the info
below may not be current and a lot of the files may be missing. This will be fixed 
shortly!*

Nifty is a Swift numerical computing library designed to provide common 
mathematical functions in a performant and easy-to-use way.

Nifty is really new and (obviously) super incomplete. The content here is
the beginnings of the framework but not yet ready for consumption. Come back 
and check Nifty out later when it's a little farther along. Or, consider
contributing! 

## Getting Started
### System Requirements

TODO: update this for new build system

Make sure you can [install Swift](https://swift.org/getting-started/).
Currently, Nifty is only being developed on Ubuntu, but there's no reason
it shouldn't work anywhere Swift does.

Currently, we're working with Swift 3 Preview 1. Other versions or previews
may not work.

### Installation

TODO: update this for swift package manager

Eventually Nifty will have a fancy installer. For now, follow the steps below
to get Nifty up and running.

- Clone this repository
- Make sure you've met the required [dependencies](#dependencies)
- Write your Swift code and drop it in the `src` directory, right alongside 
	`nifty` (make sure your code includes a new `main.swift` file if you want 
	it to run)
- Run `make` in the repository root, which will compile your code and Nifty into 
	the `run` executable
- Execute your program from the repository root with `./build/$(uname)/run`

### Usage

TODO: Update this to point to nifty demo repo

Here's a simple example of Nifty in action!

```
let n = 5000

print("\nCreating \(n)-by-\(n) random integer matrix...")
tic()
let M = randi([n,n], imax: 99999)
toc()

print("\nInverting \(n)-by-\(n) random integer matrix...")
tic()
let Minv = inv(M)
toc()
```

### Dependencies

TODO: Update all of this for new build system!

All of Nifty's external dependencies are listed in this section. 

Eventually, any missing dependencies will be resolved by a fancy installer, but
for now you may have to take some simple manual steps.

##### Make

For the time being, Nifty uses [make](https://www.gnu.org/software/make/) 
instead of the Swift Package Manager.

##### GNU C Library

Nifty uses glibc for some basic math functions; fortunately Swift has this
built in so nothing extra needs to be done.

##### Fortran

Nifty uses Fortran (needs to link against libgfortran for LAPACK). On Ubuntu, you 
can install it with `sudo apt-get install gfortran`.

##### LAPACK

Nifty relies on [LAPACK](http://www.netlib.org/lapack/) for much of its linear 
algebra functionality. Follow the steps below to get it set up.

- Download LAPACK (version 3.6.1)

- Extract the file and navigate into the directory

	```
	tar -xvf lapack-3.6.1.tgz
	cd lapack-3.6.1
	```

- Copy the file LAPACK/make.inc.example to LAPACK/make.inc and make any edits 
	if desired (the unmodified example ran just fine for us)

	```
	cp make.inc.example make.inc
	```

- Make the reference [BLAS](http://www.netlib.org/blas/) library

	```
	make blaslib
	```
- Make the LAPACK and BLAS C wrappers 
	([LAPACKE](http://www.netlib.org/lapack/lapacke.html) and 
	[CBLAS](http://www.netlib.org/blas/#_cblas))

	```
	make lapackelib
	make cblaslib
	```

- Now build and test LAPACK by simply running `make`
	- In case of a failure like "recipe for target 'znep.out' failed" during 
		testing, increase your stack size before trying again, e.g. `ulimit -s 100000`
	- You may see a few test cases fail, don't worry

- This should produce a number of .a files in the root LAPACK directory—copy 
	them into the `nifty/lib/$(uname)` directory

##### BLAS

The reference implementation of BLAS that comes with LAPACK will work just fine 
but it is not very fast. You can improve performance by using an optimized 
implementation instead (e.g. [OpenBLAS](http://www.openblas.net/)). Simply 
download or build the static library for your preferred implementation, drop it 
in `nifty/lib/$(uname)`, and modify the Makefile to link against it instead.

FYI: using the BLAS reference implementation, Nifty inverts a large matrix in 
just under 3 minutes whereas MATLAB inverts it in 6.5 seconds. Switching to 
OpenBLAS, Nifty performs the inversion about as fast as MATLAB does.

## Tests and Benchmarks

The goal is for Nifty to provide correctness and performance similar to other 
numerical computing standards. We'll be testing and benchmarking against
MATLAB and NumPy.

We will be experimenting with using the [XCTest](https://github.com/apple/swift-corelibs-xctest) 
framework as it progresses.

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

TODO: update this for swift package manager!

## Nifty Features

We are currently working on getting the core set of general math and linear algebra
functions finished:
- general functions and definitions used throughout Nifty
- matrix definition and linear algebra functionality
- vector and tensor data structures
- wrappers on glibc/math.h
- basic functions related to statistics and probability

See our [status page](Documents/Status.md) for details.

## License

This project is licensed under the Apache License, Version 2.0, a complete copy of 
which can found in LICENSE, adjacent to this file.