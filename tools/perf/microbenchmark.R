# Load libraries
library(cpp11rng)
library(microbenchmark)

# Setup for discrete sampler
vec <- LETTERS
probs <- runif(length(LETTERS))
probs <- probs / sum(probs)
num_draws <- 100000

# Benchmark std and boost
microbenchmark(
  discrete_std = sample_discrete(n = num_draws, elements = vec, prob = probs, method = "std"),
  discrete_boost = sample_discrete(n = num_draws, elements = vec, prob = probs, method = "boost"),
  discrete_custom = sample_discrete(n = num_draws, elements = vec, prob = probs, method = "custom"),
  discrete_R = sample(x = vec, size = num_draws, prob = probs, replace = TRUE),
  uniform_std = sample_uniform(n = num_draws, min = 0, max = 1, method = "std"),
  uniform_boost = sample_uniform(n = num_draws, min = 0, max = 1, method = "boost"),
  uniform_custom = sample_uniform(n = num_draws, min = 0, max = 1, method = "custom"),
  uniform_R = runif(n = num_draws, min = 0, max = 1),
  normal_std = sample_normal(n = num_draws, mean = 0, sd = 1, method = "std"),
  normal_boost = sample_normal(n = num_draws, mean = 0, sd = 1, method = "boost"),
  normal_custom = sample_normal(n = num_draws, mean = 0, sd = 1, method = "custom"), 
  normal_R = rnorm(n = num_draws, mean = 0, sd = 1),
  gamma_std = sample_gamma(n = num_draws, shape = 2.5, scale = 2, method = "std"),
  gamma_boost = sample_gamma(n = num_draws, shape = 2.5, scale = 2, method = "boost"),
  gamma_custom = sample_gamma(n = num_draws, shape = 2.5, scale = 2, method = "custom"),
  gamma_R = rgamma(n = num_draws, shape = 2.5, scale = 2)
)
