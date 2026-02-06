#ifndef UTILS_H
#define UTILS_H

#include <random>
#include <boost/random/mersenne_twister.hpp>

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