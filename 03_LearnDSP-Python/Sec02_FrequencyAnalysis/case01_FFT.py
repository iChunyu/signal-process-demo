'''
Fast Fourier Transformation (FFT)
Radix-2 Decimation in Time

XiaoCY 2021-02-01
'''

#%%
import numpy as np
import matplotlib.pyplot as plt

def inverse_index(idx,M):
    iidx = idx*0
    for k in range(M):
        iidx += (idx%2) * 2**(M-1-k)
        idx = idx//2
    return iidx

#%% data
M = 10
N = 2**M
x = np.random.randn(N,1)

#%% FFT
idx = np.arange(0,N)
iidx = inverse_index(idx,M)
X = np.array(x[iidx],dtype=complex)

for m in range(1,M+1):
    Nm = 2**m
    Nr = Nm//2
    Wm = np.exp(-1j*2*np.pi/Nm)
    Wmk = 1.
    for n in range(int(Nr)):
        for k in range(n,N,Nm):
            kp = k + Nr
            WX = X[kp] * Wmk
            X[kp] = X[k] - WX
            X[k] = X[k] + WX
        Wmk = Wmk*Wm

#%% check
Y = np.fft.fft(x,axis=0)        # Attention to this 'axis' option

plt.figure
plt.subplot(2,2,1)
plt.plot(idx,X.real)
plt.plot(idx,Y.real,'--')
plt.grid('on')
plt.xlabel('Index')
plt.ylabel('Real part')

plt.subplot(2,2,2)
plt.plot(idx,X.imag)
plt.plot(idx,Y.imag,'--')
plt.grid('on')
plt.xlabel('Index')
plt.ylabel('Imaginary part')

plt.subplot(2,2,3)
plt.plot(idx,Y.real-X.real)
plt.grid('on')
plt.xlabel('Index')
plt.ylabel('Real error')

plt.subplot(2,2,4)
plt.plot(idx,Y.imag-X.imag)
plt.grid('on')
plt.xlabel('Index')
plt.ylabel('Imaginary error')