#ifndef UTILS_H
#define UTILS_H

#include <random>
#include <boost/random/mersenne_twister.hpp>

/*!
 * Generate a standard uniform random variate by dividing a random integer
 * obtained via Mersenne Twister by the maximum possible value of the mt19937 integer type.
 */
inline double standard_uniform_draw(std::mt19937& gen) {
    constexpr double inv_divisor = 1.0 / static_cast<double>(std::mt19937::max());
    return (gen() * inv_divisor);
}

inline std::mt19937 create_std_mt19937(int random_seed = -1) {
  if (random_seed == -1) {
    std::random_device rd;
    return std::mt19937(rd());
  } else {
    return std::mt19937(random_seed);
  }
}

inline boost::random::mt19937 create_boost_mt19937(int random_seed = -1) {
  if (random_seed == -1) {
    std::random_device rd;
    return boost::random::mt19937(rd());
  } else {
    return boost::random::mt19937(random_seed);
  }
}

#endif // UTILS_H