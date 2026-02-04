# Load library
library(cpp11rng)

# Sample from discrete distribution
vec <- LETTERS
probs <- 1:length(vec)
probs <- probs / sum(probs)
(x <- sample_discrete(n = 10, elements = vec, prob = probs, random_seed = 1, method = "std"))
(x <- sample_discrete(n = 10, elements = vec, prob = probs, random_seed = 2, method = "std"))
(x <- sample_discrete(n = 10, elements = vec, prob = probs, random_seed = 1, method = "boost"))
(x <- sample_discrete(n = 10, elements = vec, prob = probs, random_seed = 2, method = "boost"))

# Sample from uniform distribution
(x <- sample_uniform(n = 10, random_seed = 1, method = "std"))
(x <- sample_uniform(n = 10, random_seed = 2, method = "std"))
(x <- sample_uniform(n = 10, random_seed = 1, method = "boost"))
(x <- sample_uniform(n = 10, random_seed = 2, method = "boost"))

# Sample from normal distribution
(x <- sample_normal(n = 10, mean = 0, sd = 1, random_seed = 1, method = "std"))
(x <- sample_normal(n = 10, mean = 0, sd = 1, random_seed = 2, method = "std"))
(x <- sample_normal(n = 10, mean = 0, sd = 1, random_seed = 1, method = "boost"))
(x <- sample_normal(n = 10, mean = 0, sd = 1, random_seed = 2, method = "boost"))

# Sample from gamma distribution
(x <- sample_gamma(n = 10, shape = 2, scale = 1, random_seed = 1, method = "std"))
(x <- sample_gamma(n = 10, shape = 2, scale = 1, random_seed = 2, method = "std"))
(x <- sample_gamma(n = 10, shape = 2, scale = 1, random_seed = 1, method = "boost"))
(x <- sample_gamma(n = 10, shape = 2, scale = 1, random_seed = 2, method = "boost"))
