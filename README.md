# Nifty

Nifty is a Swift numerical computing library designed to provide common 
mathematical functions in a performant and easy-to-use way, similar to 
what MATLAB provides, for example.

Nifty is really new and (obviously) super incomplete. The content here is
the beginnings of the framework but not yet ready for consumption. Come back 
and check Nifty out later when it's a little farther along. Or, consider
contributing! 

## Current Status

Fleshing stuff out...

## Toolbox Overview

Source code for nifty is found in /src.

The core toolbox contains general functions and definitions useful throughout
nifty. Basic math functions that depend on glibc/math.h however are located in
the nifty/math directory.

The linalg directory contains a basic library of linear algebra functions. Most
importantly, it defines the 'Matrix' struct which is used throughout linalg and 
the rest of nifty. Additionally, it implements many common matrix operations.
Notably, linalg is implemented entirely in Swift, with no dependencies on other
linear algebra packages, suck as LAPACK.

The math directory simply wraps functions from 'math.h' in easier to use Swift
functions that match the MATLAB style and convention. No functionality other
than that directly related to Glibc/math functions is provided here; other 
general math functions likely belong in /nifty/core.

The stats directory contains functions related to statistics and probability.
Basic math functions that depend on glibc/math.h however are located in
the nifty/math directory.

## Installation

TODO: insert steps for installing nifty...

## Dependencies

- core toolbox: time depends on Foundation for NSDate
- math toolbox: all files depend on import Glibc for math.h
- stat toolbox: rand and randi depend on Glibc for math.h

## Usage

TODO: insert examples of stuff

TODO: importing nifty

```
let m = zeros([5,6])
m[1,3...4] = ones([1,2])
print(m)
```

## Tests and Benchmarks

Test cases and benchmark comparisons are provided in /test, where MATLAB and 
Python (numpy) were used for verification of nifty results.

## Contributing

All contributions are welcome! If you think of a nifty feature we ought to 
have, let us know. 

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Documentation

Documentation for nifty can be found in /docs.

Complete documentation can be found: TODO...

The list below shows what functionality is currently being worked on and what
state it's in.

Current stuff, TBD for first release
- core: general functions and definitions used throughout nifty
- linalg: matrix definition and linear algebra functionality
- math: wrappers on glibc/math.h (this is the only dependency on glibc)
- stats: functions related to statistics and probability

Future work: 
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

### Functions

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
- inv (^-1):		In Progress	(need to overload ^-1 operator)
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

## License

This project is licensed under the Apache License, Version 2.0, a complete copy of 
which can found in LICENSE, adjacent to this file.

Copyright 2016 Philip Erickson
