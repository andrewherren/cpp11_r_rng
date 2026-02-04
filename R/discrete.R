#' Sample from a vector with replacement according to a vector of probability weights.
#'
#' @param n Number of samples to draw.
#' @param elements Vector from which to sample.
#' @param prob Selection probabilities for each element in the outcome vector.
#' @param random_seed Random seed for reproducibility.
#' @param method Underlying C++ sampling method to use ("std" or "boost").
#'
#' @return A vector of sampled values of length `n`.
#' @export
#'
#' @examples
#' vec <- c("A", "B", "C")
#' probs <- c(0.2, 0.5, 0.3)
#' draws <- sample_discrete(n = 10, elements = vec, prob = probs)
sample_discrete <- function(n, elements, prob, random_seed = -1, method = "std") {
  if (method == "std") {
    sampled_inds <- sample_discrete_std_cpp(n, prob, random_seed)
  } else if (method == "boost") {
    sampled_inds <- sample_discrete_boost_cpp(n, prob, random_seed)
  } else {
    stop("Unknown method")
  }
  return(elements[sampled_inds])
}
