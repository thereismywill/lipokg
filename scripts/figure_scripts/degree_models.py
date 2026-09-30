"""
Degree-distribution model fits for the LipoKG STRING protein interaction subgraph.

Fit values are produced by ``Review/powerlaw_final.py`` (powerlaw v2.0, discrete,
Clauset-Shalizi-Newman 2009) and are hard-coded here so the figure scripts stay
dependency-light.  Re-run that script to refresh them.

Headline result: the degree distribution is heavy-tailed but a pure power law is
rejected (bootstrap KS p = 8e-4); a lognormal is significantly preferred
(likelihood ratio R = -20.96, p = 1.3e-4).
"""
import numpy as np
from scipy.special import zeta
from scipy.stats import norm

FIT = {
    "n_nonzero_degree": 1852,
    "xmin": 34.0,
    "n_above_xmin": 631,
    "alpha": 2.6529,
    "alpha_ci95": (2.524, 2.782),
    "ks_D": 0.0662,
    "bootstrap_p": 0.0008,
    "bootstrap_N": 2500,
    "R_vs_exponential": -6.578,
    "p_vs_exponential": 0.576,
    "R_vs_lognormal": -20.959,
    "p_vs_lognormal": 1.2566e-4,
    "R_vs_truncated_power_law": -20.969,
    "p_vs_truncated_power_law": 9.42e-11,
    "lognormal_mu": 3.2289,
    "lognormal_sigma": 0.8751,
}

# Lower bounds tested in Review/powerlaw_sensitivity.py
XMIN_SWEEP = [
    {"xmin": 5, "n": 1716, "alpha": 1.574, "bootstrap_p": 0.000, "R_vs_lognormal": -598.88},
    {"xmin": 10, "n": 1512, "alpha": 1.848, "bootstrap_p": 0.000, "R_vs_lognormal": -247.37},
    {"xmin": 15, "n": 1282, "alpha": 2.076, "bootstrap_p": 0.000, "R_vs_lognormal": -124.19},
    {"xmin": 20, "n": 1083, "alpha": 2.287, "bootstrap_p": 0.000, "R_vs_lognormal": -58.46},
    {"xmin": 23, "n": 955, "alpha": 2.372, "bootstrap_p": 0.000, "R_vs_lognormal": -46.87},
    {"xmin": 34, "n": 631, "alpha": 2.653, "bootstrap_p": 0.000, "R_vs_lognormal": -20.96},
    {"xmin": 50, "n": 371, "alpha": 2.964, "bootstrap_p": 0.002, "R_vs_lognormal": -9.86},
]


def empirical_ccdf(degrees):
    """Return (k, P(K >= k)) at the observed distinct degree values."""
    d = np.sort(np.asarray(degrees, dtype=int))
    return d, 1.0 - np.arange(len(d)) / len(d)


def pl_ccdf(k, alpha=None, xmin=None):
    """Discrete power-law CCDF, zeta(alpha, k) / zeta(alpha, xmin); NaN below xmin."""
    alpha = FIT["alpha"] if alpha is None else alpha
    xmin = FIT["xmin"] if xmin is None else xmin
    k = np.asarray(k, dtype=float)
    out = np.full(k.shape, np.nan)
    m = k >= xmin
    out[m] = zeta(alpha, k[m]) / zeta(alpha, xmin)
    return out


def lognormal_ccdf(k, mu=None, sigma=None):
    mu = FIT["lognormal_mu"] if mu is None else mu
    sigma = FIT["lognormal_sigma"] if sigma is None else sigma
    return 1.0 - norm.cdf((np.log(np.asarray(k, dtype=float)) - mu) / sigma)


def exponential_lambda(degrees, xmin=None):
    """MLE of the shifted exponential rate on the tail k >= xmin."""
    d = np.asarray(degrees, dtype=float)
    xmin = FIT["xmin"] if xmin is None else xmin
    return 1.0 / (d[d >= xmin].mean() - xmin)


def exponential_ccdf(k, lam, xmin=None):
    xmin = FIT["xmin"] if xmin is None else xmin
    k = np.asarray(k, dtype=float)
    return np.exp(-lam * np.maximum(k - xmin, 0.0))
