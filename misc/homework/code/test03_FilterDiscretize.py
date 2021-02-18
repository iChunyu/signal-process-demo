'''
Analog-to-digital filter conversion
  1. Impulse invariance method
  2. Bilinear transformation method

XiaoCY 2021-02-07
'''

# %%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig

fs = 10.0                                           # sampling frequency (Hz)
fc = 1.0                                            # corner frequency (Hz)
b,a = sig.butter(2,2*np.pi*fc,analog=True)          # demo transfer function to be converted

# %% Filter conversion
# Impulse invariance method
r,p,k = sig.residue(b,a)
p = np.exp(p/fs)
r = r/fs
bz1,az1 = sig.invresz(r,p,k)
bz1 = bz1.real
az1 = az1.real
''' Another way
import PyDynamic.misc as misc 
bz1,az1 = misc.impinvar(b,a,fs=fs)
'''

# Bilinear transformation method
bz2,az2 = sig.bilinear(b,a,fs=fs)

# summary
f = np.linspace(0,fs,500)
_,h = sig.freqs(b,a,f*2*np.pi)
_,h1 = sig.freqz(bz1,az1,f,fs=fs)
_,h2 = sig.freqz(bz2,az2,f,fs=fs)

plt.figure
plt.plot(f,np.abs(h),label='analog')
plt.plot(f,np.abs(h1),label='impinvar')
plt.plot(f,np.abs(h2),label='bilinear')
y = plt.ylim()
plt.plot([fs/2,fs/2],y,linestyle='--')
plt.legend(loc='best')
plt.text(fs/1.9,y[1]/2,r'$\frac{f_s}{2}$',fontsize=13)
plt.grid()
plt.ylim(y)
plt.xlabel('Frequency (Hz)')
plt.ylabel('Gain')