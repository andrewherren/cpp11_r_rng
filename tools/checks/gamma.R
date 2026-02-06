# Load library
library(cpp11rng)

# Set up gamma parameters
shape <- 2.5
scale <- 2

# Define sampling parameters
num_draws <- 10000000

# Generate the data
sampled_values <- sample_gamma(n = num_draws, shape = shape, scale = scale, method = "custom")

# Q-Q plot
comp <- rgamma(num_draws, shape = shape, scale = scale)
qqplot(sampled_values, comp)
abline(0,1,col="blue",lty=3,lwd=3)

# K-S test
ks.test(pgamma(sampled_values, shape = shape, scale = scale), "punif", min = 0, max = 1)
