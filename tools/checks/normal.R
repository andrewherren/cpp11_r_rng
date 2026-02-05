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
comp <- rnorm(num_draws, mean = mean, sd = sd)
qqplot(sampled_values, comp)
abline(0,1,col="blue",lty=3,lwd=3)

# K-S test
ks.test(pnorm(sampled_values, mean = mean, sd = sd), "punif", min = 0, max = 1)
