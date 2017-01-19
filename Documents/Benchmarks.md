# Benchmarks

This document describes the various [performance benchmarks](https://github.com/nifty-swift/Nifty-benchmarks) and shows the times achieved by various packages on a [reference machine](#Benchmarks "Ubuntu 16.04, 64-bit; AMD FX-8350 4.0 GHz, 8 core CPU; 32 GB DDR3 RAM; GeForce GTX 750 Ti; 256 GB SSD").

These benchmarks are not inteded to be rigorous; rather, the intent is to simply provide a *rough* estimate of how Nifty performs relative to other packages.

##### Descriptions

1. Linear Algebra Operations

  1.1 Invert a 1000x1000 random matrix.
  
  1.2 Compute the Cholesky decomposition of a random 1000x1000 matrix.

2. Random Numbers

  2.1 Create a random 1,000,0000-dimensional vector, with whole number elements in the range 1-999.

##### Results

| Benchmark       | Date/Version           | Nifty          | MATLAB          | Python          |
|-----------------|------------------------|----------------|-----------------|-----------------|
| 1.1             | 19 Jan 2017 / 1.0.0    | **78.91 ms**   | 84.78 ms        | 103.71 ms       |
| 1.2             | 19 Jan 2017 / 1.0.0    | 32.79          | **14.22 ms**    | 24.35 ms        |
| 2.1             | 19 Jan 2017 / 1.0.0    | 7.74 ms        | 15.51 ms        | **6.89 ms**     |