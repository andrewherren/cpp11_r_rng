# Load library
library(cpp11rng)

# Set up uniform parameters
min_val <- -0.5
max_val <- 0.5

# Define sampling parameters
num_draws <- 10000000

# Generate the data
sampled_values <- sample_uniform(n = num_draws, min = min_val, max = max_val, method = "custom")

# Q-Q plot
qqplot(sampled_values, runif(num_draws, min = min_val, max = max_val))

# K-S test
ks.test(sampled_values, runif(num_draws, min = min_val, max = max_val))
