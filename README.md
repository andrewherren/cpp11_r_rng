# R Wrappers for C++ Distribution Implementations

This is a lightweight package designed to enable quick R-level comparisons between various C++ implementations of several common distributions:

1. Continuous uniform
2. Gaussian (normal)
3. Gamma
4. Categorical / discrete
5. Half cauchy
6. Half normal

Currently, this package includes three C++ backends:

1. C++ standard library (`std::random`)
2. Boost (`boost::random`)
3. Custom implementations, largely based on simplified versions of boost or numpy implementations

We developed custom C++ implementations in order to ensure cross-platform reproducibility without relying on / vendoring `boost::random`. The standard library implementations are not guaranteed / required to produce the same results across different compilers / platforms (see [here](https://stackoverflow.com/questions/26538627/c11-cross-compiler-standard-library-random-distribution-reproducibility) for discussion).

## Installation

The package can be installed via

```r
remotes::install_github("andrewherren/cpp11_r_rng")
```

## Usage

The `cpp11rng` interface is relatively simple. We provide a sampling function for each distribution, with sample size, distribution parameters, random seed, and "backend" (i.e. `"std"`, `"boost"`, or `"custom"`) as arguments.

To generate 10 draws of a uniform distribution from -2 to 2 using the C++ standard library with a seed of `1234`, simply run:

```
unif_samples <- sample_uniform(n = 10, min = -2, max = 2, random_seed = 1234, method = "std")
```

For the same task using the custom implementation, run:

```
unif_samples <- sample_uniform(n = 10, min = -2, max = 2, random_seed = 1234, method = "custom")
```

For a more elaborate example, we can sample with replacement from the letters of the alphabet using selection probabilities determined by letter position via:

```
vec <- LETTERS
probs <- 1:length(vec)
x <- sample_discrete(n = 10, elements = vec, prob = probs, method = "custom")
```

When `random_seed` is not provided, the underlying random number generator will be initilized non-deterministically (i.e. [std::random_device](https://en.cppreference.com/w/cpp/numeric/random/random_device.html)). We only ensure cross-platform reproducibility when `random_seed` is set.

When method is not provided, we default to using the custom implementation.
