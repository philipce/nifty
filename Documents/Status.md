# Implementation Status

This document lays out the current implementation status of each function/feature, as well as the plans for Nifty's future.

### Table Key

##### Implementation Status
* _N/A_: This feature is internal or private and implemented ad hoc
* _Unimplemented_: This feature exists or will exist, but no functionality has been implemented
* _Incomplete_: Implementation of this feature has begun, but critical parts are unfinished
* _Mostly Complete_: Most or all parts of this feature are implemented but still need a little work
* _Complete_: This feature is completely implemented, though there may still be planned improvements

##### Test Coverage
* _N/A_: This feature is internal or it is a feature for which testing does not make sense
* _None_: There are no unit tests specific to this feature; even if it is used indirectly in other unit tests, we should have tests targeting this feature in isolation
* _Basic_: At least one basic unit test (possibly just a sanity check) exists for this feature
* _Substantial_: Most, if not all, of this feature's critical paths are being tested
* _Benchmarked_: This feature has substantial test coverage for correctness, as well as performance benchmarking

There is no _Complete_ status for test coverage because there are always additional tests to be implemented.

### Nifty 1.0

Estimated release: end 2017

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
| det                | Unimplemented   | None           |                                                                                         |
| diag               | Unimplemented   | None           |                                                                                         |
| dot                | Mostly complete | Basic          | Need to add overloads for types other than Vecotr<Double>                               |
| eig                | Unimplemented   | None           |                                                                                         |
| eigs               | Unimplemented   | None           |                                                                                         |
| eps                | Incomplete      | None           | Use feature from standard lib from Swift 4.0                                            |
| eq                 | Completed       | Basic          |                                                                                         |
| exp                | Complete        | Basic          |                                                                                         |
| exp2               | Complete        | Basic          |                                                                                         |
| expm1              | Complete        | Basic          |                                                                                         |
| eye                | Mostly Complete | None           |                                                                                         |
| filter             | Unimplemented   | None           |                                                                                         |
| flipud             | Unimplemented   | None           |                                                                                         |
| fliplr             | Unimplemented   | None           |                                                                                         |
| floor              | Complete        | Basic          |                                                                                         |
| ge (>=)            | Complete        | None           |                                                                                         |
| gt (>)             | Unimplemented   | None           |                                                                                         |
| hypot              | Mostly Complete | None           |                                                                                         |
| ind2sub            | Mostly Complete | None           |                                                                                         |
| inf                | Incomplete      | None           |                                                                                         |
| inv (~)            | Mostly Complete | None           |                                                                                         |
| isequal            | Mostly Complete | None           | Need to add overloads and improve default behavior                                      |
| isinf              | Unimplemented   | None           |                                                                                         |
| isnan              | Incomplete      | None           |                                                                                         |
| ldivide            | Unimplemented   | None           |                                                                                         |
| le (<=)            | Complete        | None           |                                                                                         |
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
| mean               | Mostly complete | Basic          | Needs definitions for tensor                                                            |
| median             | Unimplemented   | None           |                                                                                         |
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
| Nifty              | Incomplete      | None           | Option sets and constants; revisit naming convention                                    |
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
| rdivide            | Incomplete      | None           | Has division overloads but needs rdivide func definition and overloads for other types  |
| reduce             | Unimplemented   | None           |                                                                                         |
| repmat             | Unimplemented   | None           |                                                                                         |
| reshape            | Unimplemented   | None           |                                                                                         |
| rmap               | Complete        | None           |                                                                                         |
| round              | Complete        | Basic          |                                                                                         |
| rref               | Unimplemented   | None           |                                                                                         |
| shuffle            | Unimplemented   | None           | Need this and randperm?                                                                 |
| sin                | Complete        | Basic          |                                                                                         |
| sind               | Complete        | Basic          |                                                                                         |
| sinh               | Complete        | Basic          |                                                                                         |
| size               | Complete        | Basic          |                                                                                         |
| sqrt               | Complete        | Basic          |                                                                                         |
| std                | Unimplemented   | None           |                                                                                         |
| sub2ind            | Mostly Complete | None           |                                                                                         |
| sum                | Mostly Complete | Basic          |                                                                                         |
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

### Nifty 1.1

Estimated release: mid 2018

| Feature            | Status          | Test Coverage  | Notes                                                                                   |
|--------------------|-----------------|----------------|-----------------------------------------------------------------------------------------|
| cumprod            | Unimplmented    | None           |                                                                                         |
| cumsum             | Unimplmented    | None           |                                                                                         |
| fft                | Unimplemented   | None           |                                                                                         |
| find               | Incomplete      | None           | Interface created for use with DataSeries -- need to reconcile it with MATLAB           |
| ifft               | Unimplemented   | None           |                                                                                         |
| linspace           | Unimplemented   | None           |                                                                                         |
| meshgrid           | Unimplemented   | None           |                                                                                         |
| sort               | Unimplemented   | None           |                                                                                         |

Other features:
- Basic optimization toolbox (e.g. fminsearch)
- Data frames and series
- Interpolation methods: e.g interp1, interp2, spline
- Interface to a third party plotting library

### Nifty 1.2

Estimated release: 2018

Start work on AI and machine learning features. Details TBD.

### Future Work

This is an unorganized list of ideas of things we might want to include with Nifty: 
- matlab cmds: cat, length, logspace, erf, fix, conv, deconv, polyfit, polyval, roots
- fmin, fmins, fzero
- quad, quad1, trapz
- diff, polyder
- ode solvers
- find other useful MATLAB commands: http://www.mathworks.com/help/matlab/functionlist-alpha.html
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
- gaussian processes
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