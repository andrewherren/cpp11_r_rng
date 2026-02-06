test_that("Uniform sampler quantile and moment matching", {
  # Parameter list
  min_vals <- c(-5.0, 0.0, 5.0, -5.0)
  max_vals <- c(5.0, 1.0, 6.0, -4.0)

  # Number of samples to take from each distribution
  num_draws <- 1E7
  
  # Loop over parameter combinations, running distribution quantile / moment checks at each
  for (i in seq_along(min_vals)) {
    # Unpack parameters
    min_val <- min_vals[i]
    max_val <- max_vals[i]

    # Generate data
    sampled_values <- sample_uniform(n = num_draws, min = min_val, max = max_val, method = "custom")

    # Compute true quantiles for the distribution
    probs <- c(0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95, 0.99)
    true_quantiles <- qunif(probs, min = min_val, max = max_val)
    estimated_quantiles <- unname(quantile(sampled_values, probs))

    # Test that the sampled values have the correct mean and standard deviation
    expect_equal(mean(sampled_values), (min_val + max_val) / 2, tolerance = 0.01)
    expect_equal(sd(sampled_values), (max_val - min_val) / sqrt(12), tolerance = 0.01)
    expect_equal(estimated_quantiles, true_quantiles, tolerance = 0.01)
  }
})

test_that("Uniform sampler KS test", {
  # Parameter list
  min_vals <- c(-5.0, 0.0, 5.0, -5.0)
  max_vals <- c(5.0, 1.0, 6.0, -4.0)

  # Number of samples to take from each distribution
  num_observations <- 10000
  num_tests <- 50000
  
  # Loop over parameter combinations, running distribution quantile / moment checks at each
  for (i in seq_along(min_vals)) {
    # Unpack parameters
    min_val <- min_vals[i]
    max_val <- max_vals[i]

    p_values <- rep(NA_real_, num_tests)
    for (j in 1:num_tests) {
      # Generate data
      sampled_values <- sample_uniform(n = num_observations, min = min_val, max = max_val, method = "custom")

      # Perform KS test
      ks_test <- ks.test(punif(sampled_values, min = min_val, max = max_val), "punif", min = 0, max = 1)
      p_values[j] <- ks_test$p.value
    }

    # Compute quantiles for the p value distribution (should be uniform)
    probs <- c(0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95, 0.99)
    true_quantiles <- qunif(probs, min = 0, max = 1)
    estimated_quantiles <- unname(quantile(p_values, probs))

    # Test that the sampled values have the correct mean and standard deviation
    expect_equal(estimated_quantiles, true_quantiles, tolerance = 0.01)
  }
})
