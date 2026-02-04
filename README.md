# R Wrappers for C++ Distribution Implementations

This is a lightweight package designed to enable quick R-level comparisons between various C++ implementations of several common distributions:

1. Continuous uniform
2. Gaussian (normal)
3. Gamma
4. Categorical / discrete

Currently, this package includes two C++ backends:

1. C++ standard library (`std::random`)
2. Boost (`boost::random`)

Though we intend to add custom C++ implementations that ensure cross-platform reproducibility in the same manner as `boost::random` (only taking a `std::mt19937` as input).

## Installation

The package can be installed via

```r
remotes::install_github("andrewherren/cpp11_r_rng")
```
