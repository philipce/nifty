# Benchmarks

This document describes the various [performance benchmarks](https://github.com/nifty-swift/Nifty-benchmarks) and shows the times achieved by various packages on a [reference machine](#Benchmarks "Ubuntu 16.04, 64-bit; AMD FX-8350 4.0 GHz, 8 core CPU; 32 GB DDR3 RAM; GeForce GTX 750 Ti; 256 GB SSD").

These benchmarks are not inteded to be rigorous; rather, the intent is to simply provide a *rough* estimate of how Nifty performs relative to other packages. More benchmarks will be added as Nifty matures.

*Note: We believe in avoiding premature optimization—Nifty is new and we're just trying to get things implemented. As Nifty matures, we fully expect to see significant performance improvements in some areas.*

##### Descriptions

1. Linear Algebra Operations

    1.1 Invert a 1000x1000 random matrix.

    1.2 Compute the Cholesky decomposition of a random 1000x1000 matrix.

2. Random Numbers

    2.1 Create a random 1,000,000-dimensional vector.

##### Results

| Benchmark       | Nifty          | MATLAB          | Python          | Date/Version           |
|-----------------|----------------|-----------------|-----------------|------------------------|
| 1.1             | **78.91 ms**   | 84.78 ms        | 103.71 ms       | 19 Jan 2017 / 1.0.0    |
| 1.2             | 32.79 ms       | **14.22 ms**    | 24.35 ms        | 19 Jan 2017 / 1.0.0    |
| 2.1             | 7.74 ms        | 15.51 ms        | **6.89 ms**     | 19 Jan 2017 / 1.0.0    |