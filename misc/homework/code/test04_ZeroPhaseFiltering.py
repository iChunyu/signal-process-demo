'''
Compare normal IIR filtering with zero-phase filtering
Use digital filter

XiaoCY 2021-02-18
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig

fs = 500.
t = np.arange(0,5,1/fs)
x0 = np.cos(2*np.pi*t)+0.2*np.sin(2*np.pi*10*t)     # origin signal

#%% forward prediction
N,Wn = sig.ellipord(3/(fs/2),5/(fs/2),1,40)
b,a = sig.ellip(N,1,40,Wn)

x1 = sig.lfilter(b,a,x0)
x2 = sig.filtfilt(b,a,x0)

plt.figure()
plt.plot(t,x0,label='origin')
plt.plot(t,x1,label='lfilter')
plt.plot(t,x2,label='filtflit')
plt.grid()
plt.legend(loc='lower right')
plt.xlabel('Time (s)')
plt.ylabel('Signal')
plt.show()