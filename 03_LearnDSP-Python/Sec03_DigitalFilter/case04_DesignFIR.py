'''
Use built-in functions to design FIR filter
  1) Window-based FIR filter design
  2) Frequency sampling-based FIR filter design
Band-pass filter for example

XiaoCY 2021-02-08
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig

fs = 100.
fsig = 3.

fn = np.array([fsig/3,fsig*3])
Wn = fn/(fs/2)
N = 101

t = np.arange(0,5,1/fs)
x0 = np.sin(2*np.pi*fsig*t)
xn = np.random.randn(len(x0))*0.3
x = x0+xn

f = np.linspace(0,fsig*10,500)

#%% FIR design
# Window-based FIR filter design
b1 = sig.firwin(N,Wn,pass_zero='bandpass')
x1 = sig.filtfilt(b1,1,x)
_,h1 = sig.freqz(b1,1,f,fs=fs)

# Frequency sampling-based FIR filter design
freq = np.array([0,fsig/4,fsig/3,fsig,fsig*3,fsig*4,fs/2])/(fs/2)
mreq = np.array([0,0,1,1,1,0,0])
b2 = sig.firwin2(N,freq,mreq)
x2 = sig.filtfilt(b2,1,x)
_,h2 = sig.freqz(b2,1,f,fs=fs)

# %%
plt.figure
plt.plot(f,np.abs(h1),label='firwin')
plt.plot(f,np.abs(h2),label='firwin2')
plt.grid()
plt.legend()
plt.xlabel('Frequency (Hz)')
plt.ylabel('Gain')
plt.show()

plt.figure
plt.plot(t,x,label='origin')
plt.plot(t,x1,label='firwin')
plt.plot(t,x2,label='firwin2')
plt.plot(t,x0,'--',label='real')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.ylabel('Signal')
plt.show()