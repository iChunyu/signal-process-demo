'''
Interpolate DFT to correct frequency/amplitude/phase
Take a cosine wave for example

XiaoCY 2021-02-23
'''

#%%
import numpy as np
import matplotlib.pyplot as plt

fs = 1000
N = 2000

t = np.arange(N)/fs
ax = 3.0
fx = 12.3
px = 0.5
x = ax*np.cos(2*np.pi*fx*t+px)

#%% uncorrect DFT
X = np.fft.fft(x,axis=0)
Nf = int(np.round(N/2.0+0.5))
f = np.arange(N)*fs/N
A = np.abs(X[:Nf])*2.0/N

k = np.argmax(A)
f1 = f[k]
a1 = A[k]
p1 = np.angle(X[k])

#%% ratio method: rectangular window
if A[k-1] > A[k+1]:
    dk = -A[k-1]/(A[k-1]+A[k])
else:
    dk = A[k+1]/(A[k+1]+A[k])

f2 = (k+dk)*fs/N
a2 = a1/np.sinc(dk)
p2 = p1-dk*np.pi

#%% ratio method: hanning window
win = np.hanning(N)
X3 = np.fft.fft(x*win,axis=0)
A3 = np.abs(X3[:Nf])*2.0/np.sum(win)

k3 = np.argmax(A3)
a3 = A3[k3]
p3 = np.angle(X3[k3])

if A3[k3-1] > A3[k3+1]:
    dk = (A3[k3]-2*A3[k3-1])/(A3[k3-1]+A3[k3])
else:
    dk = (2.0*A3[k3+1]-2*A3[k3])/(A3[k3+1]+A3[k3])

f3 = (k3+dk)*fs/N
a3 = a3*(1-dk**2)/np.sinc(dk)
p3 = p3-dk*np.pi

#%% results
print('%-18s%-12s%-12s%-12s%-12s\n' % ('','FFT','Rectwin','Hanning','True Value'))
print('%-18s%-12f%-12f%-12f%-12f\n' % ('Frequency (Hz)',f1,f2,f3,fx))
print('%-18s%-12f%-12f%-12f%-12f\n' % ('Amplitude',a1,a2,a3,ax))
print('%-18s%-12f%-12f%-12f%-12f\n' % ('Phase (rad)',p1,p2,p3,px))

xe1 = a1*np.cos(2*np.pi*f1*t+p1)-x
xe2 = a2*np.cos(2*np.pi*f2*t+p2)-x
xe3 = a3*np.cos(2*np.pi*f3*t+p3)-x

plt.figure()
plt.plot(t,xe1)
plt.plot(t,xe2)
plt.plot(t,xe3)
plt.grid()
plt.legend(('FFT','rect-correct','hann-corrcet'))
plt.xlabel('Time (s)')
plt.ylabel('Error')
plt.show()