'''
Compare estimated PSD with different methods

XiaoCY 2021-02-17
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as signal
import springlib as sp

fs = 1000.                  # sampling frequency (Hz)
Wp = 30./(fs/2)             # passband corner frequency (normalized)
Ws = 50./(fs/2)             # stopband corner frequency (normalized)
Rp = 1.                     # passband ripple (dB)
Rs = 40.                    # stopband attenuation (dB)

n,Wn = signal.ellipord(Wp,Ws,Rp,Rs)
b,a = signal.ellip(n,Rp,Rs,Wn)

u = np.random.randn(int(10*fs))*np.sqrt(fs/2)
x = signal.lfilter(b,a,u)

#%%
f1,px1 = signal.periodogram(x,return_onesided=True,fs=fs)
f1 = np.delete(f1,0)
px1 = np.delete(px1,0)

f2,px2 = signal.welch(x,return_onesided=True,fs=fs,noverlap=len(x)//10,nperseg=len(x)//5)
f2 = np.delete(f2,0)
px2 = np.delete(px2,0)

px3,f3 = sp.lpsd(x,fs)
_,h = signal.freqz(b,a,f3,fs=fs)

plt.figure()
plt.loglog(f1,np.sqrt(px1),label='Periodogram')
plt.loglog(f2,np.sqrt(px2),label='Welch')
plt.loglog(f3,np.sqrt(px3),label='LPSD')
plt.loglog(f3,np.abs(h),'--',label='True PSD')
plt.grid()
plt.legend()
plt.xlabel('Frequency (Hz)')
plt.ylabel('PSD')
plt.show()