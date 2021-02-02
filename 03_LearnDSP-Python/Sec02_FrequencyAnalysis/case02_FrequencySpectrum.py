'''
Plot frequency spectrum to analysis signal in frequecy domain
Key: align to frequency points

XiaoCY 2021-02-02
'''

#%%
import numpy as np
import matplotlib.pyplot as plt

#%% time domain
fs = 1000                       # sampling frequency
fsig = 100                      # signal frequency
fext = 250                      # extra frequency (noise)

t = np.arange(0,100/fsig,1/fs)  # time series
N = len(t)                      # number of samples

x = np.cos(2*np.pi*fsig*t)+0.2*np.sin(2*np.pi*fext*t)

plt.figure(1)
plt.plot(t,x)
plt.grid()
plt.title('Time Domain')
plt.xlabel('Time (s)')
plt.ylabel('Signal')

#%% frequency domain
X = np.fft.fft(x,axis=0)

Nf = int(np.ceil(N/2))
f = np.arange(0,Nf)*fs/N       # frequency points

amp = np.abs(X[0:Nf])*2/N
phase = np.angle(X[0:Nf])

plt.figure(2)
plt.subplot(2,1,1)
plt.plot(f,X[0:Nf].real)
plt.grid()
plt.xlabel('Frequency (Hz)')
plt.ylabel('Re(X)')

plt.subplot(2,1,2)
plt.plot(f,X[0:Nf].imag)
plt.grid()
plt.xlabel('Frequency (Hz)')
plt.ylabel('Im(X)')
plt.show

plt.figure(3)
plt.subplot(2,1,1)
plt.plot(f,amp)
plt.grid()
plt.xlabel('Frequency (Hz)')
plt.ylabel('Amplitude')

plt.subplot(2,1,2)
plt.plot(f,phase)
plt.grid()
plt.xlabel('Frequency (Hz)')
plt.ylabel('Phase (rad)')