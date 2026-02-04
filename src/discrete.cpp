#include <cpp11.hpp>
#include <random>
#include <boost/random/discrete_distribution.hpp>
#include <boost/random/mersenne_twister.hpp>
#include "utils.h"

[[cpp11::register]]
cpp11::writable::integers sample_discrete_std_cpp(int n, cpp11::writable::doubles prob_weights, int random_seed = -1) {
    // Initialize output vector
    cpp11::writable::integers output(n);

    // Initialize rng
    std::mt19937 gen = create_std_mt19937(random_seed);

    // Initialize and sample from distribution
    double denom = 0.0;
    int k = prob_weights.size();
    for (int i = 0; i < k; i++) denom += prob_weights[i];
    for (int i = 0; i < k; i++) prob_weights[i] = prob_weights[i] / denom;
    std::discrete_distribution<int> discrete_dist(prob_weights.begin(), prob_weights.end());
    for (int i = 0; i < n; i++) {
      output[i] = discrete_dist(gen);
    }

    return output;
}

[[cpp11::register]]
cpp11::writable::integers sample_discrete_boost_cpp(int n, cpp11::writable::doubles prob_weights, int random_seed = -1) {
    // Initialize output vector
    cpp11::writable::integers output(n);

    // Initialize rng
    boost::random::mt19937 gen = create_boost_mt19937(random_seed);

    // Initialize and sample from distribution
    double denom = 0.0;
    int k = prob_weights.size();
    for (int i = 0; i < k; i++) denom += prob_weights[i];
    for (int i = 0; i < k; i++) prob_weights[i] = prob_weights[i] / denom;
    boost::random::discrete_distribution<int> discrete_dist(prob_weights.begin(), prob_weights.end());
    for (int i = 0; i < n; i++) {
      output[i] = discrete_dist(gen);
    }

    return output;
}