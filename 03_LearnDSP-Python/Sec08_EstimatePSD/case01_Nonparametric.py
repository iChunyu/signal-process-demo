'''
Estimate PSD with nonparametric methods
(`pmtm` in `scipy` not found)

XiaoCY 2021-02-24
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as signal

fs = 1000.                  # sampling frequency (Hz)
Wp = 30./(fs/2)             # passband corner frequency (normalized)
Ws = 50./(fs/2)             # stopband corner frequency (normalized)
Rp = 1.                     # passband ripple (dB)
Rs = 40.                    # stopband attenuation (dB)

n,Wn = signal.cheb2ord(Wp,Ws,Rp,Rs)
b,a = signal.cheby2(n,Rs,Wn)
x = np.random.randn(int(10*fs))*np.sqrt(fs/2)
x = signal.lfilter(b,a,x)

#%% periodogram
N = len(x)
nfft = N
win = signal.hanning(N)
f1,px1 = signal.periodogram(x,window=win,nfft=nfft,fs=fs,return_onesided=True)
f1 = np.delete(f1,0)
px1 = np.delete(px1,0)

#%% welch
nfft = N//5
win = signal.hanning(nfft)
noverlap = np.round(nfft*0.6)
f3,px3 = signal.welch(x,window=win,nperseg=nfft,noverlap=noverlap,fs=fs,return_onesided=True)
f3 = np.delete(f3,0)
px3 = np.delete(px3,0)

#%% results
plt.figure()
plt.loglog(f1,px1,label='periodogram')
plt.loglog(f3,px3,label='welch')
plt.grid()
plt.legend()
plt.xlabel('Frequency (Hz)')
plt.ylabel('PSD')
plt.show()