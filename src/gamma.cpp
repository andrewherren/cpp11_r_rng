#include <cpp11.hpp>
#include <random>
#include <boost/random/mersenne_twister.hpp>
#include <boost/random/gamma_distribution.hpp>
#include <distributions.h>
#include "utils.h"

[[cpp11::register]]
cpp11::writable::doubles sample_gamma_std_cpp(int n, double shape, double scale, int random_seed = -1) {
    // Initialize output vector
    cpp11::writable::doubles output(n);

    // Initialize rng
    std::mt19937 gen = create_std_mt19937(random_seed);

    // Initialize and sample from distribution
    std::gamma_distribution<double> gamma_dist(shape, scale);
    for (int i = 0; i < n; i++) {
      output[i] = gamma_dist(gen);
    }

    return output;
}

[[cpp11::register]]
cpp11::writable::doubles sample_gamma_boost_cpp(int n, double shape, double scale, int random_seed = -1) {
    // Initialize output vector
    cpp11::writable::doubles output(n);

    // Initialize rng
    boost::random::mt19937 gen = create_boost_mt19937(random_seed);

    // Initialize and sample from distribution
    boost::random::gamma_distribution<double> gamma_dist(shape, scale);
    for (int i = 0; i < n; i++) {
      output[i] = gamma_dist(gen);
    }

    return output;
}

[[cpp11::register]]
cpp11::writable::doubles sample_gamma_custom_cpp(int n, double shape, double scale, int random_seed = -1) {
    // Initialize output vector
    cpp11::writable::doubles output(n);

    // Initialize rng
    std::mt19937 gen = create_std_mt19937(random_seed);

    // Sample from the gamma distribution
    for (int i = 0; i < n; i++) {
      output[i] = sample_gamma(gen, shape, scale);
    }

    return output;
}
