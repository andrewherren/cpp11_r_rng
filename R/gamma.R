#' Sample from gamma distribution with shape `shape` and scale `scale`.
#'
#' @param n Number of samples to draw.
#' @param shape Shape parameter of the gamma distribution.
#' @param scale Scale parameter of the gamma distribution.
#' @param random_seed Random seed for reproducibility.
#' @param method Underlying C++ sampling method to use ("std" or "boost").
#'
#' @return A vector of sampled values of length `n`.
#' @export
#'
#' @examples
#' draws <- sample_gamma(n = 10, shape = 1, scale = 1, random_seed = 1, method = "std")
sample_gamma <- function(n, shape = 1, scale = 1, random_seed = -1, method = "std") {
  if (method == "std") {
    return(sample_gamma_std_cpp(n, shape, scale, random_seed))
  } else if (method == "boost") {
    return(sample_gamma_boost_cpp(n, shape, scale, random_seed))
  } else {
    stop("Unknown method")
  }
}
