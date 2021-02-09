'''
Estimate filter response using white noise
Use PSD to identify system

XiaoCY 2021-02-09
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig
import springlib as sp

fs = 1000.                  # sampling frequency (Hz)
Wp = 30./(fs/2)             # passband corner frequency (normalized)
Ws = 50./(fs/2)             # stopband corner frequency (normalized)
Rp = 1.                     # passband ripple (dB)
Rs = 40.                    # stopband attenuation (dB)

n,Wn = sig.ellipord(Wp,Ws,Rp,Rs)
b,a = sig.ellip(n,Rp,Rs,Wn)

#%%
u = np.random.randn(int(10*fs))*np.sqrt(fs/2)
x = sig.lfilter(b,a,u)

pxx,f = sp.lpsd(x,fs)
_,h = sig.freqz(b,a,f,fs=fs)

plt.figure
plt.loglog(f,np.sqrt(pxx),label='PSD')
plt.loglog(f,np.abs(h),'--',label='Filter')
plt.grid()
plt.legend()
plt.xlabel('Frequency (Hz)')
plt.ylabel('Gain')
