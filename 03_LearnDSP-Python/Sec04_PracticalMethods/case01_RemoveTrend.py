'''
Remove polynomial trend in signal
Polynominal curve fitting and cancelling

XiaoCY 2021-02-14
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig

pi = np.pi

fs = 100.
fsig = 1.
p0 = np.array([-0.05, 1.0, -0.3])
t = np.arange(0,10,1/fs)
trend = np.polyval(p0,t)
x0 = np.sin(2*pi*fsig*t)+trend

#%%
p = np.polyfit(t,x0,2)
trendfit = np.polyval(p,t)
x1 = x0-trendfit

x2 = sig.detrend(x0)                # only support to remove linear trend

plt.figure()
plt.plot(t,x0,label='origin')
plt.plot(t,x1,label='polydetrend')
plt.plot(t,x2,'--',label='detrend')
plt.plot(t,trendfit,label='trendfit')
plt.plot(t,trend,'--',label='trend')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.ylabel('Signal')
plt.show()