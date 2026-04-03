# Notes on Samplers

## Truncated Normal Distribution

If we truncate

$$y \sim N(\mu,\sigma^2)$$

between $a$ and $b$, we can derive its quantile function as

$$f(p) = \mu + \Phi^{-1}\left(\Phi\left(\frac{a - \mu}{\sigma}\right) + p\left(\Phi\left(\frac{b - \mu}{\sigma}\right) - \Phi\left(\frac{a - \mu}{\sigma}\right)\right)\right)$$

and sample from the truncated distribution by plugging in uniform variates $f(u^{(1)}), f(u^{(2)}), \dots, f(u^{(m)})$ (i.e. inverse transform sampling)

[Scipy's implementation of the inverse CDF](https://github.com/scipy/scipy/blob/355b747ccae64368a7dce38825361eca6055fcd1/scipy/stats/_continuous_distns.py#L10373) involves several special functions designed to handle numeric instability, namely:

1. $\Phi\left(\frac{a - \mu}{\sigma}\right)$ is computed in log scale via [log_ndtr](https://docs.scipy.org/doc/scipy/reference/generated/scipy.special.log_ndtr.html)
2. $\Phi\left(\frac{b - \mu}{\sigma}\right) - \Phi\left(\frac{a - \mu}{\sigma}\right)$ is also computed on log scale via a [_log_gauss_mass](https://github.com/scipy/scipy/blob/355b747ccae64368a7dce38825361eca6055fcd1/scipy/stats/_continuous_distns.py#L10214) function which handles two cases:

    * If both $\frac{a - \mu}{\sigma}$ and $\frac{b - \mu}{\sigma}$ are negative, compute the difference of the log CDFs using via [logsumexp](https://en.wikipedia.org/wiki/LogSumExp)
    * If $\frac{a - \mu}{\sigma}$ and $\frac{b - \mu}{\sigma}$ straddle 0, then the difference is computed as $\log(1 - \Phi\left(\frac{a - \mu}{\sigma}\right) - \Phi\left(-\frac{b - \mu}{\sigma}\right))$ using the [log1p function](https://docs.scipy.org/doc/scipy/reference/generated/scipy.special.log1p.html) which handles catastrophic cancellation when $\Phi\left(\frac{b - \mu}{\sigma}\right) - \Phi\left(\frac{a - \mu}{\sigma}\right)$ is close to 1
3. Sum each of the above terms, along with $\log p$ using logsumexp and then compute the quantile function of their exponent via [ndtri_exp](https://docs.scipy.org/doc/scipy/reference/generated/scipy.special.ndtri_exp.html) which handles $\Phi^{-1}(\exp y)$ more accurately when $y$ is close to 0.

Without worrying about numeric instability, we can implement this much more simply in R as 

```r
sample_trunc_norm <- function(u, a, b, loc, scale) {
  qnorm(pnorm((a - loc) / scale) + u * (pnorm((b - loc) / scale) - pnorm((a - loc) / scale)))
}
```

Since this library already uses `boost::math` via the `BH` R package, we can construct this sampler from the [error functions](https://www.boost.org/doc/libs/latest/libs/math/doc/html/math_toolkit/sf_erf/error_function.html) and [error function inverses](https://www.boost.org/doc/libs/latest/libs/math/doc/html/math_toolkit/sf_erf/error_inv.html) via the following two equivalences for a standard normal distribution:

$$\Phi(x) = \frac{1}{2}\text{erfc}\left(-\frac{x}{\sqrt{2}}\right)$$
$$\Phi^{-1}(p) = -\sqrt{2}\text{erfc}^{-1}\left(2p\right)$$

```cpp
#include <boost/math/special_functions/erf.hpp>

double norm_cdf(double x) {
  return 0.5 * boost::math::erfc(x / std::sqrt(2.0));
}
double norm_inv_cdf(double p) {
  return -std::sqrt(2.0) * boost::math::erfc_inv(2.0 * p);
}
```

Since our primary application of this model is the probit sampler, we are mostly interested in two special cases:

1. Standard normal, truncated above at 0, in which case the quantile function reduces to

$$f(p) = \Phi^{-1}\left(p \times \Phi\left(0\right)\right)$$

2. Standard normal, truncated below at 0, in which case the quantile function reduces to

$$f(p) = \Phi^{-1}\left[\Phi\left(0\right) + p \times \left(1 - \Phi\left(0\right)\right)\right] = \Phi^{-1}\left[p + (1-p) \times \Phi\left(0\right)\right]$$

So we could write a probit sampler with two truncated normal sampling functions:

```cpp
static constexpr double Phi_0 = norm_cdf(0);

inline double sample_std_truncnorm_upper(std::mt19937& gen) {
  double uniform_draw = standard_uniform_draw_53bit(gen);
  return norm_inv_cdf(uniform_draw * Phi_0);
}

inline double sample_std_truncnorm_lower(std::mt19937& gen) {
  double uniform_draw = standard_uniform_draw_53bit(gen);
  return norm_inv_cdf(uniform_draw + (1 - uniform_draw) * Phi_0);
}
```
