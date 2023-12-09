import math
import scipy
import scipy.io
from scipy.optimize import curve_fit

import numpy as np
import matplotlib.pyplot as plt


# load data
dataset = scipy.io.loadmat("aer1216_2023F_proj_prop_data.mat")

J = dataset["J"].flatten()
CT = dataset["CT"].flatten()
CQ = dataset["CQ"].flatten()

print(f"dtype = {J.dtype}")

# fit data
def quadratic(x, c0, c1, c2):
    return c0 + c1 * x + c2 * x**2

def cubic(x, c0, c1, c2, c3):
    return c0 + c1 * x + c2 * x**2 + c3 * x**3

CT_opt, CT_cov = curve_fit(quadratic, J, CT)
CQ_opt, CQ_cov = curve_fit(cubic, J, CQ)
print(f"CT_coefs = {CT_opt}")
print(f"CQ_coefs = {CQ_opt}")

# plot original data with fitted curve
plt.scatter(J, CT)
plt.plot(J, quadratic(J, *CT_opt), color="r")
plt.show()

plt.scatter(J, CQ)
plt.plot(J, cubic(J, *CQ_opt), color="r")
plt.show()