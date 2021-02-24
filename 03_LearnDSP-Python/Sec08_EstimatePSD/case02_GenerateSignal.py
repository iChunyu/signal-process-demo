'''
Generate random signal with given PSD

XiaoCY 2021-02-24
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as signal

fs = 1e3
L = int(5e3)                            # frequency length (excluding DC)
N = 2*L+1                               # data length
f = np.arange(1,L+1)*fs/N

S = 3+np.exp(-(f-250)**2/2/30**2)       # square root of one-sided PSD

#%%
A = S*np.sqrt(N*fs)
phi = np.random.randn(L)*np.pi
X1 = A*np.exp(1j*phi)
X = np.append(0,X1)
X = np.append(X,np.conj(X1))
x = np.fft.ifft(X,axis=0)
x = np.real(x)

#%%
t = np.arange(N)/fs

plt.figure()
plt.plot(t,x)
plt.grid()
plt.xlabel('Time (s)')
plt.ylabel('Signal')
plt.show()

nfft = N//10
win = signal.hanning(nfft)
noverlap = np.round(nfft*0.8)
fx,pxx = signal.welch(x,window=win,nperseg=nfft,noverlap=noverlap,fs=fs,return_onesided=True)
fx = np.delete(fx,0)
pxx = np.delete(pxx,0)

plt.figure()
plt.plot(fx,np.sqrt(pxx),label='generated')
plt.plot(f,S,label='target')
plt.grid()
plt.legend()
plt.xlabel('Frequency (Hz)')
plt.ylabel('PSD')
plt.show()