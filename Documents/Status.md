# Implementation Status

This document lays out the structure of Nifty and provides the current implementation status of each
function/feature planned for Nifty's initial release.

Nifty's structure is flat, so the code for each feature below can be found in Sources in an 
identically named file. For now, information about the usage of each feature can be found in source 
comments; eventually we will have a better API reference document.

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
* _Incomplete_: Unit tests exist for this feature, but there are critical paths that are untested
* _Substantial_: Most, if not all, of this feature's critical paths are being tested
* _Benchmarked_: This feature has substantial test coverage for correctness, as well as performance 
    benchmarking

There is no _Complete_ status for test coverage because there are always additional tests to be 
implemented.

### Features

| Feature      | Status          | Test Coverage  | Notes                                                                                   |
|--------------|-----------------|----------------|-----------------------------------------------------------------------------------------|
| acos         | Complete        | None           |                                                                                         |
| acosd        | Complete        | None           |                                                                                         |
| acosh        | Complete        | None           |                                                                                         |
| asin         | Complete        | None           |                                                                                         |
| asind        | Complete        | None           |                                                                                         |
| asinh        | Complete        | None           |                                                                                         |
| atan         | Complete        | None           |                                                                                         |
| atan2        | Complete        | None           |                                                                                         |
| atan2d       | Complete        | None           |                                                                                         |
| atand        | Complete        | None           |                                                                                         |
| atanh        | Complete        | None           |                                                                                         |
| ceil         | Complete        | None           |                                                                                         |
| chol         | Unimplemented   | None           |                                                                                         |
| cond         | Unimplemented   | None           |                                                                                         |
| Constants    | Incomplete      | None           |                                                                                         |
| cos          | Complete        | None           |                                                                                         |
| cosd         | Complete        | None           |                                                                                         |
| cosh         | Complete        | None           |                                                                                         |
| det          | Unimplemented   | None           |                                                                                         |
| diag         | Unimplemented   | None           |                                                                                         |
| eig          | Unimplemented   | None           |                                                                                         |
| eigs         | Unimplemented   | None           |                                                                                         |
| eq           | Unimplemented   | None           |                                                                                         |
| exp          | Complete        | None           |                                                                                         |
| exp2         | Complete        | None           |                                                                                         |
| expm1        | Complete        | None           |                                                                                         |
| eye          | Mostly Complete | None           |                                                                                         |
| filter       | Unimplemented   | None           |                                                                                         |
| find         | Unimplemented   | None           |                                                                                         |
| floor        | Complete        | None           |                                                                                         |
| hypot        | Complete        | None           |                                                                                         |
| ge (>=)      | Complete        | None           |                                                                                         |
| gt (>)       | Unimplemented   | None           |                                                                                         |
| ind2sub      | Mostly Complete | None           |                                                                                         |
| inf          | Incomplete      | None           |                                                                                         |
| inv (~)      | Mostly Complete | None           |                                                                                         |
| isequal      | Unimplemented   | None           |                                                                                         |
| isinf        | Unimplemented   | None           |                                                                                         |
| isnan        | Incomplete      | None           |                                                                                         |
| ldivide      | Unimplemented   | None           |                                                                                         |
| le (<=)      | Complete        | None           |                                                                                         |
| linspace     | Unimplemented   | None           |                                                                                         |
| log          | Complete        | None           |                                                                                         |
| log10        | Complete        | None           |                                                                                         |
| log2         | Complete        | None           |                                                                                         |
| log1p        | Complete        | None           |                                                                                         |
| lsb          | Unimplemented   | None           |                                                                                         |
| lt (<)       | Complete        | None           |                                                                                         |
| lu           | Unimplemented   | None           |                                                                                         |
| map          | Unimplemented   | None           |                                                                                         |
| Matrix       | Mostly Complete | None           |                                                                                         |
| max          | Unimplemented   | None           |                                                                                         |
| mean         | Unimplemented   | None           |                                                                                         |
| median       | Unimplemented   | None           |                                                                                         |
| min          | Unimplemented   | None           |                                                                                         |
| minus (-)    | Unimplemented   | None           |                                                                                         |
| mldivide (-/)| Complete        | None           |                                                                                         |
| mode         | Unimplemented   | None           |                                                                                         |
| mpower (**)  | Unimplemented   | None           |                                                                                         |
| mrdivide (/) | Complete        | None           | Current implementation is less efficient--does more transposes than necessary           |
| msb          | Mostly Complete | None           |                                                                                         |
| mtimes (*)   | Mostly Complete | None           | Need to add overloads for other than Matrix*Matrix                                      |
| mvnrand      | Unimplemented   | None           |                                                                                         |
| nan          | Incomplete      | None           |                                                                                         |
| ndims        | Complete        | None           |                                                                                         |
| ne           | Unimplemented   | None           |                                                                                         |
| norm         | Unimplemented   | None           |                                                                                         |
| numel        | Complete        | None           |                                                                                         |
| ones         | Mostly Complete | None           |                                                                                         |
| pinv         | Unimplemented   | None           |                                                                                         |
| plus (+)     | Unimplemented   | None           |                                                                                         |
| poly         | Unimplemented   | None           |                                                                                         |
| pow (**)     | Complete        | None           |                                                                                         |
| power (.**)  | Unimplemented   | None           |                                                                                         |
| prod         | Unimplemented   | None           |                                                                                         |
| qr           | Unimplemented   | None           |                                                                                         |
| rand         | Complete        | None           |                                                                                         |
| randi        | Complete        | None           |                                                                                         |
| randn        | Complete        | None           |                                                                                         |
| randperm     | Unimplemented   | None           |                                                                                         |
| rank         | Unimplemented   | None           |                                                                                         |
| rdivide      | Unimplemented   | None           |                                                                                         |
| reduce       | Unimplemented   | None           |                                                                                         |
| repmat       | Unimplemented   | None           |                                                                                         |
| reshape      | Unimplemented   | None           |                                                                                         |
| rmap         | Complete        | None           |                                                                                         |
| round        | Complete        | None           |                                                                                         |
| rref         | Unimplemented   | None           |                                                                                         |
| sin          | Complete        | None           |                                                                                         |
| sind         | Complete        | None           |                                                                                         |
| sinh         | Complete        | None           |                                                                                         |
| size         | Complete        | None           |                                                                                         |
| sqrt         | Complete        | None           |                                                                                         |
| std          | Unimplemented   | None           |                                                                                         |
| sub2ind      | Mostly Complete | None           |                                                                                         |
| sum          | Unimplemented   | None           |                                                                                         |
| svd          | Unimplemented   | None           |                                                                                         |
| tan          | Complete        | None           |                                                                                         |
| tand         | Complete        | None           |                                                                                         |
| tanh         | Complete        | None           |                                                                                         |
| Tensor       | Unimplemented   | None           |                                                                                         |
| tic          | Mostly Complete | None           |                                                                                         |
| times (*)    | Incomplete      | None           | Need to add overloads                                                                   |
| toc          | Mostly Complete | None           |                                                                                         |
| trace        | Complete        | None           |                                                                                         |
| transpose    | Complete        | None           |                                                                                         |
| var          | Unimplemented   | None           |                                                                                         |
| Vector       | Unimplemented   | None           |                                                                                         |
| zeros        | Complete        | None           |                                                                                         |


### Future Work

This is an unorganized list of ideas of things we might want to include with Nifty 
(TODO: flesh out this stream of conciousness type list):

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
- errors: mean square error, etc.
- time series
- neural net
- particle filter
- setdiff
- svm
- unique
- viterbi

