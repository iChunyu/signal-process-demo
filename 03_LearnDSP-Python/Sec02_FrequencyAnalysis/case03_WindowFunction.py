'''
Compare different window functions to estimate spectrum
Key: the coefficient to normalize the spectrum

XiaoCY 2021-02-02
'''

#%%
import numpy as np
import matplotlib.pyplot as plt

#%%
fs = 1000                           # sampling frequency
fsig = 100                          # signal frequency

t = np.arange(0,100/fsig,1/fs)      # time series
N = len(t)                          # number of samples

x = np.cos(2*np.pi*fsig*t)

Nf = int(np.ceil(N/2))
f = np.arange(0,Nf)*fs/N

#%% 
# rectangular window
X = np.fft.fft(x,axis=0)
amp = np.abs(X[0:Nf])*2/N

plt.figure(1)
plt.plot(f,amp,label='rectwin')

# hanning window
win = np.hanning(N)
X = np.fft.fft(x*win,axis=0)
amp = np.abs(X[0:Nf])*2/np.sum(win)
plt.plot(f,amp,label='hanning')

# hamming window
win = np.hamming(N)
X = np.fft.fft(x*win,axis=0)
amp = np.abs(X[0:Nf])*2/np.sum(win)
plt.plot(f,amp,label='hamming')

# blackman window
win = np.blackman(N)
X = np.fft.fft(x*win,axis=0)
amp = np.abs(X[0:Nf])*2/np.sum(win)
plt.plot(f,amp,label='blackman')

plt.grid()
plt.legend()
plt.xlabel('Frequency (Hz)')
plt.ylabel('Spectrum')
plt.xlim(80,120)