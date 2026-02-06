#ifndef DISTRIBUTIONS_H
#define DISTRIBUTIONS_H
#include <random>

/*!
 * Generate a standard uniform random variate by dividing a random integer
 * obtained via Mersenne Twister by the maximum possible value of the mt19937 integer type.
 * 
 * Updated approach uses two 32-bit integers to generate more unique values, see:
 * https://github.com/numpy/numpy/blob/0d7986494b39ace565afda3de68be528ddade602/numpy/random/src/mt19937/mt19937.h#L56
 */
inline double standard_uniform_draw(std::mt19937& gen) {
  int32_t a = gen() >> 5;
  int32_t b = gen() >> 6;
  return (a * 67108864.0 + b) / 9007199254740992.0;
}

/*!
 * Standard normal sampler implementing Marsaglia's polar method.
 * 
 * Other references: https://en.wikipedia.org/wiki/Marsaglia_polar_method
 */
class standard_normal {
 public:
  standard_normal() {
    has_cached_value_ = false;
    cached_value_ = 0.0;
  }

  double operator()(std::mt19937& gen) {
    if (has_cached_value_) {
      has_cached_value_ = false;
      return cached_value_;      
    } else {
      double u, v, r, s;
      do {
        u = standard_uniform_draw(gen) * 2.0 - 1.0;
        v = standard_uniform_draw(gen) * 2.0 - 1.0;
        s = u * u + v * v;
      } while (s >= 1.0 || s == 0.0);
      r = std::sqrt(-2.0 * std::log(s) / s);
      has_cached_value_ = true;
      cached_value_ = v * r;
      return u * r;
    }
  }

 private:
  bool has_cached_value_;
  double cached_value_;
};

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

#endif // DISTRIBUTIONS_H