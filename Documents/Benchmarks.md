# Benchmarks

This document describes the various [performance benchmarks](https://github.com/nifty-swift/Nifty-benchmarks) and shows the times achieved by various packages on a [reference machine](#Benchmarks "Ubuntu 16.04, 64-bit; AMD FX-8350 4.0 GHz, 8 core CPU; 32 GB DDR3 RAM; GeForce GTX 750 Ti; 256 GB SSD").

These benchmarks are not inteded to be rigorous; rather, the intent is to simply provide a *rough* estimate of how Nifty performs relative to other packages.

##### Descriptions

1. Linear Algebra Operations

  1.1 Invert a 1000x1000 matrix of random whole numbers. Average value over 100 trials.

##### Results

| Benchmark       | Date/Version           | Nifty          | MATLAB          | Python          |
|-----------------|------------------------|----------------|-----------------|-----------------|
| 1.1             | 19 Jan 2017 / 1.0.0    | **61.44 ms**   | 84.78 ms        | 103.71 ms       |