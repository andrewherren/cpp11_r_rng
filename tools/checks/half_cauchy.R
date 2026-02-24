# Load library
library(cpp11rng)
library(extraDistr)

# Define sampling parameters
num_draws <- 10000000

# Generate the data
sampled_values <- sample_half_cauchy(n = num_draws, method = "custom")

# K-S test
ks.test(phcauchy(sampled_values), "punif", min = 0, max = 1)
