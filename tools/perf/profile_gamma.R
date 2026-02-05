# Load libraries
library(cpp11rng)

# Set sampler parameters
num_draws <- 1000000

# Sample from gamma distribution with std::gamma_distribution
x_std <- sample_gamma(num_draws, shape = 2, scale = 2, method = "std")
cat(paste0("Sampled ", num_draws, " values from std::gamma_distribution\n"))

# Sample from gamma distribution with boost::gamma_distribution
x_boost <- sample_gamma(num_draws, shape = 2, scale = 2, method = "boost")
cat(paste0("Sampled ", num_draws, " values from boost::gamma_distribution\n"))

# Sample from gamma distribution with custom implementation
x_custom <- sample_gamma(num_draws, shape = 2, scale = 2, method = "custom")
cat(paste0("Sampled ", num_draws, " values from custom gamma implementation\n"))
