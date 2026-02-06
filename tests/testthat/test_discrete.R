test_that("Discrete sampler histogram matching", {
  # Parameter list
  probs_list <- list(
    1:20,
    30:1,
    c(3,2,4,5,1,7,8,9,6),
    1:20,
    30:1,
    c(3,2,4,5,1,7,8,9,6)
  )
  for (i in seq_along(probs_list)) {
    probs <- probs_list[[i]]
    probs_list[[i]] <- probs / sum(probs)
  }
  elements_list <- list(
    1:20,
    0:29,
    1:9,
    as.character(1:20),
    as.character(0:29),
    as.character(1:9)
  )

  # Number of samples to take from each distribution
  num_draws <- 1E7
  
  # Loop over parameter combinations, running distribution quantile / moment checks at each
  for (i in seq_along(probs_list)) {
    # Unpack parameters
    probs <- probs_list[[i]]
    elements <- elements_list[[i]]

    # Generate data
    sampled_values <- sample_discrete(n = num_draws, elements = elements, prob = probs, method = "custom")

    # Compute table for the distribution
    sample_table <- table(factor(sampled_values, levels = elements))
    table_sorted <- as.numeric(sample_table)
    table_probs <- table_sorted / sum(table_sorted)

    # Test that the sampled values have the correct mean and standard deviation
    expect_equal(table_probs, probs, tolerance = 0.01)
  }
})
