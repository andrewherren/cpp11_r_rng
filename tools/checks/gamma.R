# Load library
library(cpp11rng)

# Set up gamma parameters
shape <- 0.5
scale <- 1

# Define sampling parameters
num_draws <- 10000000

# Generate the data
sampled_values <- sample_gamma(n = num_draws, shape = shape, scale = scale, method = "custom")

# Q-Q plot
qqplot(sampled_values, rgamma(num_draws, shape = shape, scale = scale))

# K-S test
ks.test(sampled_values, rgamma(num_draws, shape = shape, scale = scale))
