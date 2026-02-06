test_that("Gamma sampler quantile and moment matching", {
  # Parameter list
  shapes <- c(0.5, 1.0, 2.5, 0.5, 1.0, 2.5, 0.5, 1.0, 2.5)
  scales <- c(0.5, 0.5, 0.5, 1.0, 1.0, 1.0, 3.0, 3.0, 3.0)

  # Number of samples to take from each distribution
  num_draws <- 1E7
  
  # Loop over parameter combinations, running distribution quantile / moment checks at each
  for (i in seq_along(shapes)) {
    # Unpack parameters
    shape <- shapes[i]
    scale <- scales[i]

    # Generate data
    sampled_values <- sample_gamma(n = num_draws, shape = shape, scale = scale, method = "custom")

    # Compute true quantiles for the distribution
    probs <- c(0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95, 0.99)
    true_quantiles <- qgamma(probs, shape = shape, scale = scale)
    estimated_quantiles <- unname(quantile(sampled_values, probs))

    # Test that the sampled values have the correct mean and standard deviation
    expect_equal(mean(sampled_values), shape * scale, tolerance = 0.01)
    expect_equal(sd(sampled_values), sqrt(shape * scale^2), tolerance = 0.01)
    expect_equal(estimated_quantiles, true_quantiles, tolerance = 0.01)
  }
})

test_that("Gamma sampler KS test", {
  # Parameter list
  shapes <- c(0.5, 1.0, 2.5, 0.5, 1.0, 2.5)
  scales <- c(0.5, 0.5, 0.5, 2.0, 2.0, 2.0)

  # Number of samples to take from each distribution
  num_observations <- 10000
  num_tests <- 50000
  
  # Loop over parameter combinations, running distribution quantile / moment checks at each
  for (i in seq_along(shapes)) {
    # Unpack parameters
    shape <- shapes[i]
    scale <- scales[i]

    p_values <- rep(NA_real_, num_tests)
    for (j in 1:num_tests) {
      # Generate data
      sampled_values <- sample_gamma(n = num_observations, shape = shape, scale = scale, method = "custom")

      # Perform KS test
      ks_test <- suppressWarnings(ks.test(pgamma(sampled_values, shape = shape, scale = scale), "punif", min = 0, max = 1, exact = FALSE))
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
