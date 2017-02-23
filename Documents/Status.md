# Implementation Status

This document lays out the structure of Nifty and provides the current implementation status of each
function/feature planned for Nifty's initial release.

Nifty's structure is flat, so the code for each feature below can be found in Sources in an 
identically named file. Nifty's API can be found at [nifty-swift.org](http://nifty-swift.org).

Being that Nifty is a work in progress, it's probably true that not all functionality desired in the
first release is present. The first release will focus on core functionality essential to any useful
numerical computing package, postponing the higher level, niftier algorithms to a future release. If
you notice any functionality missing from this list that you consider core, please suggest it and we
will add it to the list!

#### Table Key

##### Implementation Status
* _N/A_: This feature is internal or private and implemented ad hoc
* _Unimplemented_: This feature exists or will exist, but no functionality has been implemented
* _Incomplete_: Implementation of this feature has begun, but critical parts are unfinished
* _Mostly Complete_: Most or all parts of this feature are implemented but still need a little work
* _Complete_: This feature is completely implemented, though there may still be planned improvements

##### Test Coverage
* _N/A_: This feature is internal or it is a feature for which testing does not make sense
* _None_: There are no unit tests specific to this feature; even if it is used indirectly in other 
    unit tests, we should have tests targeting this feature in isolation
* _Basic_: Unit tests exist for this feature, but there are critical paths that are untested
* _Substantial_: Most, if not all, of this feature's critical paths are being tested
* _Benchmarked_: This feature has substantial test coverage for correctness, as well as performance 
    benchmarking

There is no _Complete_ status for test coverage because there are always additional tests to be 
implemented.

### Features

| Feature            | Status          | Test Coverage  | Notes                                                                                   |
|--------------------|-----------------|----------------|-----------------------------------------------------------------------------------------|
| acos               | Complete        | Basic          |                                                                                         |
| acosd              | Complete        | Basic          |                                                                                         |
| acosh              | Complete        | Basic          |                                                                                         |
| asin               | Complete        | Basic          |                                                                                         |
| asind              | Complete        | Basic          |                                                                                         |
| asinh              | Complete        | Basic          |                                                                                         |
| atan               | Complete        | Basic          |                                                                                         |
| atan2              | Complete        | Basic          |                                                                                         |
| atan2d             | Complete        | Basic          |                                                                                         |
| atand              | Complete        | Basic          |                                                                                         |
| atanh              | Complete        | Basic          |                                                                                         |
| ceil               | Complete        | Basic          |                                                                                         |
| chol               | Mostly complete | Basic          |                                                                                         |
| cond               | Unimplemented   | None           |                                                                                         |
| cos                | Complete        | Basic          |                                                                                         |
| cosd               | Complete        | Basic          |                                                                                         |
| cosh               | Complete        | Basic          |                                                                                         |
| cross              | Mostly complete | Basic          |                                                                                         |
| cumprod            | Unimplmented    | None           |                                                                                         |
| cumsum             | Unimplmented    | None           |                                                                                         |
| DataFrame          | Incomplete      | None           | Basic start to pandas clone                                                             |
| DataSeries         | Incomplete      | None           | Basic start to pandas clone                                                             |
| det                | Unimplemented   | None           |                                                                                         |
| diag               | Unimplemented   | None           |                                                                                         |
| dot                | Mostly complete | Basic          | Need to add overloads for types other than Vecotr<Double>                               |
| eig                | Unimplemented   | None           |                                                                                         |
| eigs               | Unimplemented   | None           |                                                                                         |
| eps                | Incomplete      | None           |                                                                                         |
| eq                 | Completed       | Basi           |                                                                                         |
| exp                | Complete        | Basic          |                                                                                         |
| exp2               | Complete        | Basic          |                                                                                         |
| expm1              | Complete        | Basic          |                                                                                         |
| eye                | Mostly Complete | None           |                                                                                         |
| fft                | Unimplemented   | None           |                                                                                         |
| filter             | Unimplemented   | None           |                                                                                         |
| find               | Incomplete      | None           | Interface created for use with DataSeries -- need to reconcile it with MATLAB           |
| flipud             | Unimplemented   | None           |                                                                                         |
| fliplr             | Unimplemented   | None           |                                                                                         |
| floor              | Complete        | Basic          |                                                                                         |
| ge (>=)            | Complete        | None           |                                                                                         |
| gt (>)             | Unimplemented   | None           |                                                                                         |
| hypot              | Mostly Complete | None           |                                                                                         |
| ifft               | Unimplemented   | None           |                                                                                         |
| ind2sub            | Mostly Complete | None           |                                                                                         |
| inf                | Incomplete      | None           |                                                                                         |
| interp1            | Incomplete      | None           | Interface created for use with DataSeries -- need to reconcile it with MATLAB           |
| inv (~)            | Mostly Complete | None           |                                                                                         |
| isequal            | Mostly Complete | None           | Need to add overloads and improve default behavior                                      |
| isinf              | Unimplemented   | None           |                                                                                         |
| isnan              | Incomplete      | None           |                                                                                         |
| ldivide            | Unimplemented   | None           |                                                                                         |
| le (<=)            | Complete        | None           |                                                                                         |
| linspace           | Unimplemented   | None           |                                                                                         |
| log                | Complete        | Basic          |                                                                                         |
| log10              | Complete        | Basic          |                                                                                         |
| log2               | Complete        | Basic          |                                                                                         |
| log1p              | Complete        | Basic          |                                                                                         |
| lsb                | Unimplemented   | None           |                                                                                         |
| lt (<)             | Complete        | None           |                                                                                         |
| lu                 | Mostly Complete | Basic          |                                                                                         |
| map                | Unimplemented   | None           |                                                                                         |
| Matrix             | Mostly Complete | Basic          | Need to add reshaping inits; make iterable                                              |
| max                | Unimplemented   | None           |                                                                                         |
| mean               | Complete        | Basic          |                                                                                         |
| median             | Unimplemented   | None           |                                                                                         |
| meshgrid           | Unimplemented   | None           |                                                                                         |
| min                | Unimplemented   | None           |                                                                                         |
| minus (-)          | Mostly Complete | Basic          | Need to add overloads                                                                   |
| mldivide (-/)      | Complete        | Basic          |                                                                                         |
| mode               | Unimplemented   | None           |                                                                                         |
| mpower (**)        | Unimplemented   | None           |                                                                                         |
| mrdivide (/)       | Complete        | Basic          | Current implementation is less efficient--does more transposes than necessary           |
| msb                | Mostly Complete | None           |                                                                                         |
| mtimes (*)         | Mostly Complete | None           | Need to add overloads for other than Matrix*Matrix                                      |
| MultikeyDictionary | Mostly Complete | Substantial    | Currently only have basic insert/find/remove                                            |
| mvnrnd             | Mostly Complete | Basic          |                                                                                         |
| nan                | Incomplete      | None           |                                                                                         |
| ndims              | Complete        | None           |                                                                                         |
| ne                 | Unimplemented   | None           |                                                                                         |
| Nifty              | Incomplete      | None           | Option sets and constants                                                               |
| norm               | Incomplete      | Basic          | L2 norm complete, need L1, frobenius, etc...                                            |
| numel              | Complete        | None           |                                                                                         |
| ones               | Mostly Complete | None           |                                                                                         |
| pinv               | Unimplemented   | None           |                                                                                         |
| plus (+)           | Mostly Complete | Basic          | Need to add overloads                                                                   |
| poly               | Unimplemented   | None           |                                                                                         |
| pow (**)           | Complete        | None           |                                                                                         |
| power (.**)        | Unimplemented   | None           |                                                                                         |
| prod               | Unimplemented   | None           |                                                                                         |
| qr                 | Unimplemented   | None           |                                                                                         |
| rand               | Complete        | None           |                                                                                         |
| randa              | Mostly Complete | None           |                                                                                         |
| randi              | Complete        | None           |                                                                                         |
| randn              | Complete        | None           |                                                                                         |
| randperm           | Unimplemented   | None           |                                                                                         |
| rank               | Unimplemented   | None           |                                                                                         |
| rdivide            | Unimplemented   | None           |                                                                                         |
| reduce             | Unimplemented   | None           |                                                                                         |
| repmat             | Unimplemented   | None           |                                                                                         |
| reshape            | Unimplemented   | None           |                                                                                         |
| rmap               | Complete        | None           |                                                                                         |
| round              | Complete        | Basic          |                                                                                         |
| rref               | Unimplemented   | None           |                                                                                         |
| shuffle            | Unimplemented   | None           |                                                                                         |
| sin                | Complete        | Basic          |                                                                                         |
| sind               | Complete        | Basic          |                                                                                         |
| sinh               | Complete        | Basic          |                                                                                         |
| size               | Complete        | Basic          |                                                                                         |
| sort               | Unimplemented   | None           |                                                                                         |
| sqrt               | Complete        | Basic          |                                                                                         |
| std                | Unimplemented   | None           |                                                                                         |
| sub2ind            | Mostly Complete | None           |                                                                                         |
| sum                | Unimplemented   | None           |                                                                                         |
| svd                | Mostly Complete | Basic          | Need to resolve ambiguity between function calls requiring specifying output type       |
| swap               | Incomplete      | None           | Need to add support for vectors, tensors, matrix columns, etc.                          |
| tan                | Complete        | Basic          |                                                                                         |
| tand               | Complete        | Basic          |                                                                                         |
| tanh               | Complete        | Basic          |                                                                                         |
| Tensor             | Mostly complete | Basic          | Need to add reshaping inits; make iterable                                              |
| tic                | Mostly Complete | None           |                                                                                         |
| times (*)          | Incomplete      | None           | Need to add overloads                                                                   |
| toc                | Mostly Complete | None           |                                                                                         |
| trace              | Complete        | Basic          |                                                                                         |
| transpose          | Mostly Complete | None           | Need to add overloads for generic types                                                 |
| tril               | Incomplete      | None           |                                                                                         |
| triu               | Incomplete      | None           |                                                                                         |
| unique             | Unimplemented   | None           |                                                                                         |
| var                | Unimplemented   | None           |                                                                                         |
| Vector             | Mostly complete | Basic          | Need to add reshaping inits; make iterable                                              |
| zeros              | Complete        | Basic          |                                                                                         |


### Future Work

This is an unorganized, stream-of-consciousness type list of ideas of things we might want to include with Nifty: 
- comb through matlab to find relevant functions:
    http://www.mathworks.com/help/matlab/functionlist-alpha.html    
- matlab cmds: cat, length, logspace, erf, fix, conv, deconv, polyfit, polyval, roots
- interpolation: interp1, interp2, spline
- fmin, fmins, fzero
- quad, quad1, trapz
- diff, polyder
- ode solvers
- predefined input functions: e.g. gensig, sawtooth, square, stepfun
- laplace, ilaplace
- transfer functions, series, feedback
- complex functionality from glibc/math:
  (http://www.gnu.org/software/libc/manual/html_node/Mathematics.html)
- special functions from glibc/math:
  (http://www.gnu.org/software/libc/manual/html_node/Special-Functions.html)
- look at wrapping stuff from GSL
- bayes net
- decision tree
- distance metrics: manhattan, euclidean, mahalanobis, etc
- filter2 etc
- fminsearch... optimization toolbox
- gaussian process
- halton sequence, sobol, hammersley
- image
- kalman filter
- k nearest neighbor classifier
- kd tree
- k means
- pcg random
- gmm
- mdp/pomdp/hmm
- stats: p values, t/z test, etc
- errors: mean square error, etc.
- time series
- neural net
- particle filter
- setdiff
- svm
- viterbi

