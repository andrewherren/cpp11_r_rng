#' Sample from uniform distribution on the interval from `min` to `max`.
#'
#' @param n Number of samples to draw.
#' @param min Minimum value of the uniform distribution.
#' @param max Maximum value of the uniform distribution.
#' @param random_seed Random seed for reproducibility.
#' @param method Underlying C++ sampling method to use ("std", "boost", or "custom").
#'
#' @return A vector of sampled values of length `n`.
#' @export
#'
#' @examples
#' draws <- sample_uniform(n = 10, method = "std")
sample_uniform <- function(n, min = 0, max = 1, random_seed = -1, method = "custom") {
  if (method == "std") {
    return(sample_uniform_std_cpp(n, min, max, random_seed))
  } else if (method == "boost") {
    return(sample_uniform_boost_cpp(n, min, max, random_seed))
  } else if (method == "custom") {
    return(sample_uniform_custom_cpp(n, min, max, random_seed))
  } else {
    stop("Unknown method")
  }
}
