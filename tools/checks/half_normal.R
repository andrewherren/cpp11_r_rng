# Load library
library(cpp11rng)
library(extraDistr)

# Define sampling parameters
num_draws <- 10000000

# Generate the data
sampled_values <- sample_half_normal(n = num_draws, method = "custom")

# Q-Q plot
comp <- rhnorm(num_draws)
qqplot(sampled_values, comp)
abline(0,1,col="blue",lty=3,lwd=3)

# K-S test
ks.test(phnorm(sampled_values), "punif", min = 0, max = 1)
