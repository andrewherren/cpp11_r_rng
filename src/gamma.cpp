#include <cpp11.hpp>
#include <random>
#include <boost/random/mersenne_twister.hpp>
#include <boost/random/gamma_distribution.hpp>
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

/*!
 * Generate a single sample from a gamma distribution using a combination of algorithms
 * When shape < 1.0, use the Ahrens-Dieter method
 * When shape > 1.0, use the Marsaglia-Tsang method
 * When shape == 1.0, sample an exponential via inverse transform method
 * When shape == 0.0, return 0.0
 * https://en.wikipedia.org/wiki/Gamma_distribution#Random_variate_generation
 */
double single_gamma_sample(double shape, double scale, std::mt19937& gen) {
  if (shape == 1.0) {
    return -std::log(standard_uniform_draw(gen)) * scale;
  } else if (shape < 1.0) {
    // Modified Ahrens-Dieter used by numpy:
    // https://github.com/numpy/numpy/blob/main/numpy/random/src/distributions/distributions.c
    while (true) {
      double u = standard_uniform_draw(gen);
      double v0 = standard_uniform_draw(gen);
      double v = -std::log(v0);
      if (u <= 1.0 - shape) {
        double x = std::pow(u, 1.0 / shape);
        if (x <= v) {
          return x * scale;
        }
      } else {
        double y = -std::log((1 - u) / shape);
        double x = std::pow(1.0 - shape + shape * y, 1.0 / shape);
        if (x <= v + y) {
          return x * scale;
        }
      }
    }
  } else if (shape > 1.0) {
    // Marsaglia-Tsang from numpy
    double b = shape - 1.0 / 3.0;
    double c = 1.0 / std::sqrt(9.0 * b);
    while (true) {
      double x, v;
      do {
        // Marsaglia's polar method for standard normal 
        double u1, u2, s;
        do {
          u1 = standard_uniform_draw(gen) * 2.0 - 1.0;
          u2 = standard_uniform_draw(gen) * 2.0 - 1.0;
          s = u1 * u1 + u2 * u2;
        } while (s >= 1.0 || s == 0.0);
        x = u1 * std::sqrt(-2.0 * std::log(s) / s);            
        v = 1.0 + c * x;
      } while (v <= 0.0);
      v = v * v * v;
      double u = standard_uniform_draw(gen);
      if (u < 1.0 - 0.0331 * (x * x) * (x * x)) {
          return b * v * scale;
      }
      if (std::log(u) < 0.5 * x * x + b * (1.0 - v + std::log(v))) {
          return b * v * scale;
      }
    }
  } else {
    return 0.0;
  }
}

[[cpp11::register]]
cpp11::writable::doubles sample_gamma_custom_cpp(int n, double shape, double scale, int random_seed = -1) {
    // Initialize output vector
    cpp11::writable::doubles output(n);

    // Initialize rng
    std::mt19937 gen = create_std_mt19937(random_seed);

    // Sample from the gamma distribution
    for (int i = 0; i < n; i++) {
      output[i] = single_gamma_sample(shape, scale, gen);
    }

    return output;
}
