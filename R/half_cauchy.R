#' Sample from standard half cauchy distribution.
#'
#' @param n Number of samples to draw.
#' @param random_seed Random seed for reproducibility.
#' @param method Underlying C++ sampling method to use ("std", "boost", or "custom").
#'
#' @return A vector of sampled values of length `n`.
#' @export
#'
#' @examples
#' draws <- sample_half_cauchy(n = 10, random_seed = 1, method = "std")
sample_half_cauchy <- function(n, random_seed = -1, method = "custom") {
  if (method == "std") {
    return(sample_half_cauchy_std_cpp(n, random_seed))
  } else if (method == "boost") {
    return(sample_half_cauchy_boost_cpp(n, random_seed))
  } else if (method == "custom") {
    return(sample_half_cauchy_custom_cpp(n, random_seed))
  } else {
    stop("Unknown method")
  }
}
