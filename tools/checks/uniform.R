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
comp <- runif(num_draws, min = min_val, max = max_val)
qqplot(sampled_values, comp)
abline(0,1,col="blue",lty=3,lwd=3)

# K-S test
ks.test(sampled_values, "punif", min = 0, max = 1)
