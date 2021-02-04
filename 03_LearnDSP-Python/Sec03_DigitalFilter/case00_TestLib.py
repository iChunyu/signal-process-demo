'''
Test the functions in `springlib`

XiaoCY 2021-02-04
'''

# %%
import numpy as np
import matplotlib.pyplot as plt
import springlib as sp

# %% Test LPSD
fs = 10
data = np.random.randn(10000)*np.sqrt(fs/2)

pxx,f = sp.lpsd(data,fs)

plt.loglog(f,np.sqrt(pxx))
plt.grid()