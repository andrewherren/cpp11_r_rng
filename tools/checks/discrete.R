# Load library
library(cpp11rng)

# Set up discrete distribution parameters
vec <- LETTERS
probs <- 1:length(vec)
probs <- probs / sum(probs)

# Define sampling parameters
num_draws <- 100000000

# Generate the data
sampled_letters <- sample_discrete(n = num_draws, elements = vec, prob = probs, method = "custom")

# Compute the table
table(sampled_letters) / num_draws

# Histogram of empirical and true probability errors
hist(table(sampled_letters) / num_draws - probs)

# K-S test
ks.test(table(sampled_letters) / num_draws, probs)
