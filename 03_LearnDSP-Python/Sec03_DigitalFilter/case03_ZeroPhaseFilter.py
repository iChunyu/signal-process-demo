'''
Compare normal IIR filtering with zero-phase filtering
Use digital filter

XiaoCY 2021-02-08
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig

fs = 100.                               # sampling frequency (Hz)
fsig = 1.                               # signal frequency (Hz)

Wp = 3*fsig/(fs/2)                      # passband corner frequency (digital)
Ws = 5*fsig/(fs/2)                      # stopband corner frequency (digital)
Rp = 1.                                 # passband ripple (dB)
Rs = 40.                                # stopband attenuation (dB)

t = np.arange(0,5,1/fs)
x0 = np.sin(2*np.pi*fsig*t)
xn = np.random.randn(len(x0))*0.3
x = x0+xn

#%%
N,Wn = sig.ellipord(Wp,Ws,Rp,Rs)        # digital filter
b,a = sig.ellip(N,Rp,Rs,Wn)

x1 = sig.lfilter(b,a,x)                 # normal filtering
x2 = sig.filtfilt(b,a,x)                # zero-phase filtering

# manual zero-phase filtering
x3 = sig.lfilter(b,a,x)                 # step 1: normal filtering
x3 = x3[::-1]                           # step 2: flip
x3 = sig.lfilter(b,a,x3)                # step 3: normal filtering
x3 = x3[::-1]                           # step 4: flip

#%%
plt.figure
plt.plot(t,x,label='origin')
plt.plot(t,x0,'--',label='real')
plt.plot(t,x1,label='lfilter')
plt.plot(t,x2,label='filtfilt')
plt.plot(t,x3,'-.',label='manual')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.ylabel('Signal')