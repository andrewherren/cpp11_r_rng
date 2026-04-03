#include <cpp11.hpp>
#include <random>
#include <boost/random/mersenne_twister.hpp>
#include <boost/random/normal_distribution.hpp>
#include <distributions.h>
#include "utils.h"

[[cpp11::register]]
cpp11::writable::doubles sample_half_normal_std_cpp(int n, int random_seed = -1) {
  // Initialize output vector
  cpp11::writable::doubles output(n);

  // Initialize rng
  std::mt19937 gen = create_std_mt19937(random_seed);

  // Initialize and sample from distribution
  std::normal_distribution<double> norm_dist(0, 1);
  for (int i = 0; i < n; i++) {
    output[i] = std::abs(norm_dist(gen));
  }

  return output;
}

[[cpp11::register]]
cpp11::writable::doubles sample_half_normal_boost_cpp(int n, int random_seed = -1) {
  // Initialize output vector
  cpp11::writable::doubles output(n);

  // Initialize rng
  boost::random::mt19937 gen = create_boost_mt19937(random_seed);

  // Initialize and sample from distribution
  boost::random::normal_distribution<double> norm_dist(0, 1);
  for (int i = 0; i < n; i++) {
    output[i] = std::abs(norm_dist(gen));
  }

  return output;
}

[[cpp11::register]]
cpp11::writable::doubles sample_half_normal_custom_cpp(int n, int random_seed = -1) {
  // Initialize output vector
  cpp11::writable::doubles output(n);

  // Initialize rng
  std::mt19937 gen = create_std_mt19937(random_seed);

  // Sample from the normal distribution two draws at a time
  // using uniform draws and caching results.
  // https://en.wikipedia.org/wiki/Marsaglia_polar_method
  standard_normal dist;
  for (int i = 0; i < n; i++) {
    output[i] = std::abs(dist(gen));
  }

  return output;
}
