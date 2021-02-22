'''
Short Time Fourier Transform (STFT)
WARNING: s1~=s2, why?

XiaoCY 2021-02-22
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as signal

fs = 1000.0
t = np.arange(0,100,1/fs)
x = signal.chirp(t,0,t[-1],300,method='quadratic')

#%%
nfft = 512
win = signal.hanning(nfft)
noverlap = int(nfft*0.6)

f1,t1,s1 = signal.spectrogram(x,fs,window=win,noverlap=noverlap,
    nfft=nfft,mode='complex',detrend=False)

f2,t2,s2 = signal.stft(x,fs,window=win,noverlap=noverlap,
    nfft=nfft,nperseg=nfft,return_onesided=True,boundary=None,padded=False)

#%%
plt.figure()
plt.plot(t,x)
plt.grid()
plt.xlabel('Time (s)')
plt.ylabel('Chirp')
plt.xlim(0,15)
plt.show()

plt.figure()
plt.pcolormesh(t1,f1,np.abs(s1))
plt.colorbar()
plt.xlabel('Time (s)')
plt.ylabel('Frequency (Hz)')
plt.show()

plt.figure()
plt.pcolormesh(t2,f2,np.abs(s2))
plt.colorbar()
plt.xlabel('Time (s)')
plt.ylabel('Frequency (Hz)')
plt.show()
# %%
