test_that("Normal sampler quantile and moment matching", {
  # Parameter list
  means <- c(-5.0, 0.0, 5.0, -5.0, 0.0, 5.0, -5.0, 0.0, 5.0)
  sds <- c(0.5, 0.5, 0.5, 1.0, 1.0, 1.0, 3.0, 3.0, 3.0)

  # Number of samples to take from each distribution
  num_draws <- 1E7
  
  # Loop over parameter combinations, running distribution quantile / moment checks at each
  for (i in seq_along(means)) {
    # Unpack parameters
    mean <- means[i]
    sd <- sds[i]

    # Generate data
    sampled_values <- sample_normal(n = num_draws, mean = mean, sd = sd, method = "custom")

    # Compute true quantiles for the distribution
    probs <- c(0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95, 0.99)
    true_quantiles <- qnorm(probs, mean = mean, sd = sd)
    estimated_quantiles <- unname(quantile(sampled_values, probs))

    # Test that the sampled values have the correct mean and standard deviation
    expect_equal(mean(sampled_values), mean, tolerance = 0.01)
    expect_equal(sd(sampled_values), sd, tolerance = 0.01)
    expect_equal(estimated_quantiles, true_quantiles, tolerance = 0.01)
  }
})

test_that("Normal sampler KS test", {
  # Parameter list
  means <- c(-5.0, 0.0, 5.0, -5.0, 0.0, 5.0)
  sds <- c(0.5, 0.5, 0.5, 3.0, 3.0, 3.0)

  # Number of samples to take from each distribution
  num_observations <- 10000
  num_tests <- 50000
  
  # Loop over parameter combinations, running distribution quantile / moment checks at each
  for (i in seq_along(means)) {
    # Unpack parameters
    mean <- means[i]
    sd <- sds[i]

    p_values <- rep(NA_real_, num_tests)
    for (j in 1:num_tests) {
      # Generate data
      sampled_values <- sample_normal(n = num_observations, mean = mean, sd = sd, method = "custom")

      # Perform KS test
      ks_test <- ks.test(pnorm(sampled_values, mean = mean, sd = sd), "punif", min = 0, max = 1)
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
