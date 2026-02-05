#include <cpp11.hpp>
#include <random>
#include <boost/random/discrete_distribution.hpp>
#include <boost/random/mersenne_twister.hpp>
#include "utils.h"

[[cpp11::register]]
cpp11::writable::integers sample_discrete_std_cpp(int n, cpp11::writable::doubles probability_weights, int random_seed = -1) {
  // Initialize output vector
  cpp11::writable::integers output(n);

  // Initialize rng
  std::mt19937 gen = create_std_mt19937(random_seed);

  // Initialize and sample from distribution
  double denom = 0.0;
  int k = probability_weights.size();
  for (int i = 0; i < k; i++) denom += probability_weights[i];
  for (int i = 0; i < k; i++) probability_weights[i] = probability_weights[i] / denom;
  std::discrete_distribution<int> discrete_dist(probability_weights.begin(), probability_weights.end());
  for (int i = 0; i < n; i++) {
    output[i] = discrete_dist(gen) + 1;
  }

  return output;
}

[[cpp11::register]]
cpp11::writable::integers sample_discrete_boost_cpp(int n, cpp11::writable::doubles probability_weights, int random_seed = -1) {
  // Initialize output vector
  cpp11::writable::integers output(n);

  // Initialize rng
  boost::random::mt19937 gen = create_boost_mt19937(random_seed);

  // Initialize and sample from distribution
  double denom = 0.0;
  int k = probability_weights.size();
  for (int i = 0; i < k; i++) denom += probability_weights[i];
  for (int i = 0; i < k; i++) probability_weights[i] = probability_weights[i] / denom;
  boost::random::discrete_distribution<int> discrete_dist(probability_weights.begin(), probability_weights.end());
  for (int i = 0; i < n; i++) {
    output[i] = discrete_dist(gen) + 1;
  }

  return output;
}

/*!
 * Walker-Vose alias method for sampling with replacement from a weighted discrete distribution.
 * 
 * Simplified from https://github.com/boostorg/random/blob/develop/include/boost/random/discrete_distribution.hpp
 * Other references: https://en.wikipedia.org/wiki/Alias_method
 */
class walker_vose {
 public:
  template<typename Iterator>
  walker_vose(Iterator first, Iterator last) {
    n_ = std::distance(first, last);
    probability_.resize(n_);
    alias_.resize(n_);

    // Compute probability normalizing factor
    double sum = 0.0;
    for (auto it = first; it != last; ++it) {
      sum += *it;
    }
    
    // Build alias table using Walker's algorithm
    std::vector<double> p(n_);
    std::vector<int> below_average, above_average;

    for (int i = 0; i < n_; ++i) {
      p[i] = (*(first + i)) * n_ / sum;
      if (p[i] < 1.0) {
        below_average.push_back(i);
      } else {
        above_average.push_back(i);
      }
    }
    
    while (!below_average.empty() && !above_average.empty()) {
      int j = below_average.back(); below_average.pop_back();
      int i = above_average.back(); above_average.pop_back();
      
      probability_[j] = p[j];
      alias_[j] = i;
      p[i] = (p[i] + p[j]) - 1.0;
      
      if (p[i] < 1.0) {
        below_average.push_back(i);
      } else {
        above_average.push_back(i);
      }
    }
    
    while (!above_average.empty()) {
      probability_[above_average.back()] = 1.0;
      above_average.pop_back();
    }
    
    while (!below_average.empty()) {
      probability_[below_average.back()] = 1.0;
      below_average.pop_back();
    }
  }
  
  int operator()(std::mt19937& gen) {
    double u = gen() * inv_divisor;
    int i = static_cast<int>(u * n_);
    double y = u * n_ - i;
    return (y < probability_[i]) ? i : alias_[i];
  }

 private:
  std::vector<double> probability_;
  std::vector<int> alias_;
  int n_;
  static constexpr double inv_divisor = 1.0 / static_cast<double>(std::mt19937::max());
};

[[cpp11::register]]
cpp11::writable::integers sample_discrete_custom_cpp(int n, cpp11::doubles prob, int random_seed = -1) {
  // Initialize output vector
  cpp11::writable::integers output(n);

  // Initialize rng
  std::mt19937 gen = create_std_mt19937(random_seed);

  // Initialize and sample from distribution
  walker_vose dist(prob.begin(), prob.end());
  for (int i = 0; i < n; i++) {
    output[i] = dist(gen) + 1;
  }
    
  return output;
}