'''
Add zeros to the end of the data serie
Compare the difference of the frequency spectrum with the origin
Pay attention to the factor to normalize the spectrum

XiaoCY 2021-02-03
'''

#%%
import numpy as np
import matplotlib.pyplot as plt

fs = 1000                               # sampling frequency
fsig = 100                              # signal frequency

t = np.arange(0,100/fsig,1/fs)          # time series
N = len(t)                              # number of samples
L = int(2**(np.ceil(np.log2(N))+4))     # number of extended samples

x = np.cos(2*np.pi*fsig*t)
xe = np.append(x,np.zeros(L-N))

#%%
X = np.fft.fft(x,axis=0)
Nf = int(np.ceil(N/2))
f = np.arange(0,Nf)*fs/N
amp = np.abs(X[0:Nf])*2/N

plt.figure
plt.plot(f,amp,label='origin')

# add zeros
Xe = np.fft.fft(xe,axis=0)
Nfe = int(np.ceil(L/2))
fe = np.arange(0,Nfe)*fs/L
ampe = np.abs(Xe[0:Nfe])*2/N

plt.plot(fe,ampe,label='extended')
plt.grid()
plt.legend()
plt.xlabel('Frequency (Hz)')
plt.ylabel('Amplitude')
plt.xlim(90,110)