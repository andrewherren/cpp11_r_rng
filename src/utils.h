#ifndef UTILS_H
#define UTILS_H

#include <random>
#include <boost/random/mersenne_twister.hpp>

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