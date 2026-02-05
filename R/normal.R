#' Sample from normal distribution with mean `mean` and standard deviation `sd`.
#'
#' @param n Number of samples to draw.
#' @param mean Mean of the normal distribution.
#' @param sd Standard deviation of the normal distribution.
#' @param random_seed Random seed for reproducibility.
#' @param method Underlying C++ sampling method to use ("std", "boost", or "custom").
#'
#' @return A vector of sampled values of length `n`.
#' @export
#'
#' @examples
#' draws <- sample_normal(n = 10, mean = 0, sd = 1, random_seed = 1, method = "std")
sample_normal <- function(n, mean = 0, sd = 1, random_seed = -1, method = "std") {
  if (method == "std") {
    return(sample_normal_std_cpp(n, mean, sd, random_seed))
  } else if (method == "boost") {
    return(sample_normal_boost_cpp(n, mean, sd, random_seed))
  } else if (method == "custom") {
    return(sample_normal_custom_cpp(n, mean, sd, random_seed))
  } else {
    stop("Unknown method")
  }
}
