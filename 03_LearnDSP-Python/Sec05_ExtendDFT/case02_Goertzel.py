'''
Goertzel algorithm to calcudate DFT
(iteration algorithm)
PSD estimation in animation

XiaoCY 2021-02-22
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig

# create time series
fs = 1000.                  # sampling frequency (Hz)
Wp = 30./(fs/2)             # passband corner frequency (normalized)
Ws = 50./(fs/2)             # stopband corner frequency (normalized)
Rp = 1.                     # passband ripple (dB)
Rs = 40.                    # stopband attenuation (dB)

n,Wn = sig.ellipord(Wp,Ws,Rp,Rs)
b,a = sig.ellip(n,Rp,Rs,Wn)
u = np.random.randn(int(10*fs))*np.sqrt(fs/2)
x = sig.lfilter(b,a,u)

#%%
N = len(x)
nfft = N//2
k = np.arange(1,nfft+1)
W = np.exp(1j*2*np.pi*k/N)
f = k*fs/N

_,h = sig.freqz(b,a,f,fs=fs)
h = np.abs(h)

# initialize
X = np.zeros(nfft)
nFrame = 30
dN = N//nFrame
plt.figure()
for k in range(N):
    X = x[k] + W*X

    if k % dN == 0:
        P = np.abs(X)*np.sqrt(2/fs/N)

        plt.cla()
        plt.loglog(f,P,label='real-time')
        plt.loglog(f,h,'--',label='true value')
        plt.grid()
        plt.legend()
        plt.xlabel('Frequency (Hz)')
        plt.ylabel('PSD')
        plt.ylim(1e-4,1e1)
        plt.pause(0.2)