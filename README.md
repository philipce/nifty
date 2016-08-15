# Nifty

[![License](https://img.shields.io/hexpm/l/plug.svg)](LICENSE)

Nifty is a Swift numerical computing library designed to provide common 
mathematical functions in a performant and easy-to-use way, similar to 
what MATLAB provides, for example.

Nifty is really new and (obviously) super incomplete. The content here is
the beginnings of the framework but not yet ready for consumption. Come back 
and check Nifty out later when it's a little farther along. Or, consider
contributing! 

## Getting Started
### System Requirements

Make sure you can [install Swift](https://swift.org/getting-started/).
Currently, Nifty is only being developed on Ubuntu, but there's no reason
it shouldn't work anywhere Swift does.

### Installation

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

Nifty uses Fortran (it needs to link against libgfortran for LAPACK). On Ubuntu, you 
can install it with `sudo apt-get install gfortran`.

##### LAPACK

Nifty relies on [LAPACK](http://www.netlib.org/lapack/) for much of its linear 
algebra functionality. Follow the steps below to get it set up.

- Download LAPACK (version 3.6.1)

- Extract the file and navigate into it

	```
	tar -xvf lapack-3.6.1.tgz
	cd lapack-3.6.1.tgz
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
		testing, increase your stack size with `ulimit -s 100000` and try again
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
MATLAB and Numpy.

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

This section gives an overview of how Nifty is organized.

Source code for nifty is found in `src/nifty`. The directory is flat with every 
Nifty function or data structure in its own, appropriately named source file for
easy perusal of the code.

Currently we don't build Nifty as its own module for import by the user.
Instead, user code is compiled together with Nifty and should be placed in 
`src`, alongside `nifty`. This will eventually change when Nifty is made into 
a module.

The `build` directory contains compiled Swift code, organized into 
subdirectories by platform. Currently, this just contains the exectuable built
from Nifty and user code, though eventually this will contain the built 
static library, module, and documention files.

TODO: doc

TODO: include

TODO: lib

TODO: test

## Current Status

Currently working on getting the core set of general math and linear algebra
functions finished.
- general functions and definitions used throughout Nifty
- matrix definition and linear algebra functionality
- vector and tensor data structures
- wrappers on glibc/math.h
- basic functions related to statistics and probability

Here's an alphabetical list of all Nifty functions so far, for the most part
they are named and function similarly to MATLAB... 

Following the function name is the state, one of: blank, which means it hasn't 
been started; "In Progress", which indicates it is being worked on; "Awaiting 
Test", which indicates it is pretty much working, just awaiting formal test and 
(if applicable) benchmarking; "Failing", indicates testing revealed a bug; 
"Complete", indicates a formal test/benchmark has been created and passed.

This is the set of functions we require to be ready, meaning at least in the 
"Awaiting Test" phase, for the first release.

- acos:			Awaiting Test
- acosd:		Awaiting Test
- acosh:		Awaiting Test
- asin:			Awaiting Test
- asind:		Awaiting Test
- asinh:		Awaiting Test
- atan:			Awaiting Test
- atan2:		Awaiting Test
- atan2d:		Awaiting Test
- atand:		Awaiting Test
- atanh:		Awaiting Test
- ceil:			Awaiting Test
- chol:
- cond:
- cos:			Awaiting Test
- cosd:			Awaiting Test
- cosh:			Awaiting Test
- det:	
- diag:
- eig:
- eigs:
- eq:			Awaiting Test
- exp:			Awaiting Test
- exp2:			Awaiting Test
- expm1:		Awaiting Test
- eye:			Awaiting Test
- filter:
- find:			Awaiting Test
- floor:		Awaiting Test
- hypot:		Awaiting Test
- ge:			Awaiting Test
- gt:			Awaiting Test
- ind2sub:		Awaiting Test
- inf:			Awaiting Test
- inv (^-1):	In Progress	(need to overload ^-1 operator)
- isequal:		In Progress
- isinf: 		Awaiting Test
- isnan: 		Awaiting Test
- ldivide:
- le:			Awaiting Test
- linspace:
- log:			Awaiting Test
- log10:		Awaiting Test
- log2:			Awaiting Test
- log1p:		Awaiting Test
- lt:			Awaiting Test
- lu:
- map:
- matrix:		In Progress
- max:			In Progress
- mean:
- median:
- min:			In Progress
- minus (-):		Awaiting Test
- mldivide:
- mode:
- mpower (**):		In Progress
- mrdivide (/):
- msb: 			Awaiting Test
- mtimes (*):		In Progress
- mvnrand:
- nan:			Awaiting Test
- ndims:		Awaiting Test
- ne:			Awaiting Test
- norm:
- numel:		Awaiting Test
- ones:			Awaiting Test
- operators: 		Awaiting Test
- pinv: 
- plus (+):		Awaiting Test
- poly:
- pow (**):		Awaiting Test
- power (.**):		In Progress
- prod:
- qr:
- rand:			Awaiting Test
- randi:		Awaiting Test
- randn:
- randperm:
- rank:
- rdivide (./):
- reduce:
- repmat:
- reshape:
- rmap:			Awaiting Test
- round:		Awaiting Test
- rref:
- sin:			Awaiting Test
- sind:			Awaiting Test
- sinh:			Awaiting Test
- size:			Awaiting Test
- sqrt:			Awaiting Test
- std:
- sub2ind:		In Progress
- sum:			In Progress
- svd:
- tan:			Awaiting Test
- tand:			Awaiting Test
- tanh:			Awaiting Test
- tic: 			Awaiting Test
- times (*):		Awaiting Test
- toc: 			Awaiting Test
- trace:		Awaiting Test
- transpose (~):	Awaiting Test
- var:
- zeros:		Awaiting Test

## Future Work

This is just a stream of conciousness type list of things to do in the future:
- comb through matlab to find relevant functions:
    http://www.mathworks.com/help/matlab/functionlist-alpha.html	
- complex functionality from glibc/math:
  (http://www.gnu.org/software/libc/manual/html_node/Mathematics.html)
- special functions from glibc/math:
  (http://www.gnu.org/software/libc/manual/html_node/Special-Functions.html)
- bayes net
- decision tree
- distance metrics: manhattan, euclidean, mahalanobis, etc
- fft
- filter2 etc
- fminsearch... optimization toolbox
- gaussian process
- halton sequence
- image
- kalman filter
- kd tree
- kmeans
- mdp/pomdp/hmm
- mean square error
- neural net
- particle filter
- setdiff
- svm
- unique
- viterbi

## License

This project is licensed under the Apache License, Version 2.0, a complete copy of 
which can found in LICENSE, adjacent to this file.

Copyright 2016 Philip Erickson
