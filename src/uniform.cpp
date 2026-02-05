#include <cpp11.hpp>
#include <random>
#include <boost/random/mersenne_twister.hpp>
#include <boost/random/uniform_real_distribution.hpp>
#include "utils.h"

[[cpp11::register]]
cpp11::writable::doubles sample_uniform_std_cpp(int n, double min, double max, int random_seed = -1) {
    // Initialize output vector
    cpp11::writable::doubles output(n);

    // Initialize rng
    std::mt19937 gen = create_std_mt19937(random_seed);

    // Initialize and sample from distribution
    std::uniform_real_distribution<double> unif_dist(min, max);
    for (int i = 0; i < n; i++) {
      output[i] = unif_dist(gen);
    }

    return output;
}

[[cpp11::register]]
cpp11::writable::doubles sample_uniform_boost_cpp(int n, double min, double max, int random_seed = -1) {
    // Initialize output vector
    cpp11::writable::doubles output(n);

    // Initialize rng
    boost::random::mt19937 gen = create_boost_mt19937(random_seed);

    // Initialize and sample from distribution
    boost::random::uniform_real_distribution<double> unif_dist(min, max);
    for (int i = 0; i < n; i++) {
      output[i] = unif_dist(gen);
    }

    return output;
}

[[cpp11::register]]
cpp11::writable::doubles sample_uniform_custom_cpp(int n, double min, double max, int random_seed = -1) {
    // Initialize output vector
    cpp11::writable::doubles output(n);

    // Initialize rng
    std::mt19937 gen = create_std_mt19937(random_seed);

    // Sample from the distribution directly by 
    // generating a standard uniform sample and then
    // adjusting to the target min and max range
    double range = max - min;
    for (int i = 0; i < n; i++) {
      output[i] = standard_uniform_draw(gen) * range + min;
    }

    return output;
}
