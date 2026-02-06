# Reproducibility check script
# ----------------------------
# Generate data from the four custom samplers supported by cpp11rng
# and compare results across platforms

# Load libraries
library(cpp11rng)

# Set seed for reproducibility
random_seed <- 1234
set.seed(random_seed)

# Determine how many draws to take
n_draws <- 20000

# Generate uniform data
unif_samples <- sample_uniform(n = n_draws, min = -1, max = 2, random_seed = random_seed, method = "custom")

# Generate normal data
normal_samples <- sample_normal(n = n_draws, mean = -0.5, sd = 1.5, random_seed = random_seed, method = "custom")

# Generate gamma data
gamma_samples <- sample_gamma(n = n_draws, shape = 2, scale = 0.5, random_seed = random_seed, method = "custom")

# Generate discrete data
vec <- LETTERS
probs <- 1:length(vec)
discrete_samples <- sample_discrete(n = n_draws, elements = vec, prob = probs, random_seed = random_seed, method = "custom")

# # Save results
# combined_df <- data.frame(
#   unif = unif_samples,
#   normal = normal_samples,
#   gamma = gamma_samples,
#   discrete = discrete_samples
# )
# write.csv(combined_df, "tools/reproducibility/samples.csv", row.names = FALSE)

# Load stored results
combined_df <- read.csv(
  "tools/reproducibility/samples.csv"
)
unif_comparison <- as.numeric(combined_df[, 1])
normal_comparison <- as.numeric(combined_df[, 2])
gamma_comparison <- as.numeric(combined_df[, 3])
discrete_comparison <- combined_df[, 4]

# Set tolerance level for numeric comparisons
TOL <- 0.000001

# Compare uniform variables
unif_mismatch <- !all(abs(unif_samples - unif_comparison) < TOL)
unif_mismatch_loc <- abs(unif_samples - unif_comparison) >= TOL
if (unif_mismatch) {
  cat(
    "Differences in uniform samples: \n",
    paste0(
      (1:length(unif_samples))[unif_mismatch_loc],
      ": ",
      unif_comparison[unif_mismatch_loc],
      " vs ",
      unif_samples[unif_mismatch_loc],
      collapse = "\n"
    )
  )
} else {
  cat("No mismatches found in the uniform samples\n")
}

# Compare normal variables
normal_mismatch <- !all(abs(normal_samples - normal_comparison) < TOL)
normal_mismatch_loc <- abs(normal_samples - normal_comparison) >= TOL
if (normal_mismatch) {
  cat(
    "Differences in normal samples: \n",
    paste0(
      (1:length(normal_samples))[normal_mismatch_loc],
      ": ",
      normal_comparison[normal_mismatch_loc],
      " vs ",
      normal_samples[normal_mismatch_loc],
      collapse = "\n"
    )
  )
} else {
  cat("No mismatches found in the normal samples\n")
}

# Compare gamma variables
gamma_mismatch <- !all(abs(gamma_samples - gamma_comparison) < TOL)
gamma_mismatch_loc <- abs(gamma_samples - gamma_comparison) >= TOL
if (gamma_mismatch) {
  cat(
    "Differences in gamma samples: \n",
    paste0(
      (1:length(gamma_samples))[gamma_mismatch_loc],
      ": ",
      gamma_comparison[gamma_mismatch_loc],
      " vs ",
      gamma_samples[gamma_mismatch_loc],
      collapse = "\n"
    )
  )
} else {
  cat("No mismatches found in the gamma samples\n")
}

# Compare discrete variables
discrete_mismatch <- !all(discrete_samples == discrete_comparison)
discrete_mismatch_loc <- discrete_samples != discrete_comparison
if (discrete_mismatch) {
  cat(
    "Differences in discrete samples: \n",
    paste0(
      (1:length(discrete_samples))[discrete_mismatch_loc],
      ": ",
      discrete_comparison[discrete_mismatch_loc],
      " vs ",
      discrete_samples[discrete_mismatch_loc],
      collapse = "\n"
    )
  )
} else {
  cat("No mismatches found in the discrete samples")
}
