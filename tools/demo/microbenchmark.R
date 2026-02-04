# Load libraries
library(cpp11rng)
library(microbenchmark)

# Setup for discrete sampler
vec <- LETTERS
probs <- runif(length(LETTERS))
probs <- probs / sum(probs)
num_draws <- 10000

# Benchmark std and boost
microbenchmark(
  discrete_std = sample_discrete(n = num_draws, elements = vec, prob = probs, method = "std"),
  discrete_boost = sample_discrete(n = num_draws, elements = vec, prob = probs, method = "boost"),
  uniform_std = sample_uniform(n = num_draws, min = 0, max = 1, method = "std"),
  uniform_boost = sample_uniform(n = num_draws, min = 0, max = 1, method = "boost"),
  normal_std = sample_normal(n = num_draws, mean = 0, sd = 1, method = "std"),
  normal_boost = sample_normal(n = num_draws, mean = 0, sd = 1, method = "boost"),
  gamma_std = sample_gamma(n = num_draws, shape = 2, scale = 1, method = "std"),
  gamma_boost = sample_gamma(n = num_draws, shape = 2, scale = 1, method = "boost")
)
