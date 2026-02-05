# Load library
library(cpp11rng)

# Set up normal parameters
mean <- -0.5
sd <- 0.5

# Define sampling parameters
num_draws <- 10000000

# Generate the data
sampled_values <- sample_normal(n = num_draws, mean = mean, sd = sd, method = "custom")

# Q-Q plot
qqplot(sampled_values, rnorm(num_draws, mean = mean, sd = sd))

# K-S test
ks.test(sampled_values, rnorm(num_draws, mean = mean, sd = sd))
