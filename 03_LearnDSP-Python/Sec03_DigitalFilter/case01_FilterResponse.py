'''
Design filter using built-in functions
Show frequency response
Low-pass analog filter for example

XiaoCY 2021-02-05
'''

# %%
import numpy as np
import matplotlib.pyplot as plt
from scipy import signal as sig

Wp = 1.                     # passband corner frequency (rad/s)
Ws = 3.                     # stopband corner frequency (rad/s)
Rp = 1.                     # passband ripple (dB)
Rs = 40.                    # stopband attenuation (dB)
w = np.linspace(0,5,500)

# %%
# Butterworth
n,Wn = sig.buttord(Wp,Ws,Rp,Rs,analog=True)
b,a = sig.butter(n,Wn,analog=True)

w1,h = sig.freqs(b,a,w)
plt.plot(w,20*np.log10(np.abs(h)),label='Butter (N='+str(n)+')')

# Chebyshev Type I
n,Wn = sig.cheb1ord(Wp,Ws,Rp,Rs,analog=True)
b,a = sig.cheby1(n,Rp,Wn,analog=True)

w1,h = sig.freqs(b,a,w)
plt.plot(w,20*np.log10(np.abs(h)),label='Chebyshev1 (N='+str(n)+')')

# Chebyshev Type II
n,Wn = sig.cheb2ord(Wp,Ws,Rp,Rs,analog=True)
b,a = sig.cheby2(n,Rs,Wn,analog=True)

w1,h = sig.freqs(b,a,w)
plt.plot(w,20*np.log10(np.abs(h)),label='Chebyshev2 (N='+str(n)+')')

# Elliptic
n,Wn = sig.ellipord(Wp,Ws,Rp,Rs,analog=True)
b,a = sig.ellip(n,Rp,Rs,Wn,analog=True)

w1,h = sig.freqs(b,a,w)
plt.plot(w,20*np.log10(np.abs(h)),label='Elliptic (N='+str(n)+')')
plt.legend()
plt.grid()
plt.xlabel('Frequency (rad/s)')
plt.ylabel('Gain (dB)')