#include <cpp11.hpp>
#include <random>
#include <boost/random/mersenne_twister.hpp>
#include <boost/random/normal_distribution.hpp>
#include "utils.h"

[[cpp11::register]]
cpp11::writable::doubles sample_normal_std_cpp(int n, double mean, double sd, int random_seed = -1) {
    // Initialize output vector
    cpp11::writable::doubles output(n);

    // Initialize rng
    std::mt19937 gen = create_std_mt19937(random_seed);

    // Initialize and sample from distribution
    std::normal_distribution<double> norm_dist(mean, sd);
    for (int i = 0; i < n; i++) {
      output[i] = norm_dist(gen);
    }

    return output;
}

[[cpp11::register]]
cpp11::writable::doubles sample_normal_boost_cpp(int n, double mean, double sd, int random_seed = -1) {
    // Initialize output vector
    cpp11::writable::doubles output(n);

    // Initialize rng
    boost::random::mt19937 gen = create_boost_mt19937(random_seed);

    // Initialize and sample from distribution
    boost::random::normal_distribution<double> norm_dist(mean, sd);
    for (int i = 0; i < n; i++) {
      output[i] = norm_dist(gen);
    }

    return output;
}
