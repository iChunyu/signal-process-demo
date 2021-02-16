'''
Predict data Forward/backword
Use AR model to do prediction
Use extended data to cancel transient dynamic in filtering

WARNING: `iarburg` funtion is copied from MATLAB and should be checked for future use

XiaoCY 2021-02-16
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig

# copied from MATLAB function: arburg
# only support vector data
# !!! NOT exatcly the same (why?) !!!
def iarburg(x,p):
    N = len(x)
    
    # Initialization
    efp = x[1:].copy()
    ebp = x[:-1].copy()
    a = np.zeros(p+1)
    rc = np.zeros(p)
    e = x.dot(x)/N
    a[0] = 1.0

    for m in range(p):
        # Calculate the next order reflection (parcor) coefficient
        k = (-2.0*np.dot(ebp,efp))/(np.dot(efp,efp)+np.dot(ebp,ebp))
        rc[m] = k

        # Update the forward and backward prediction errors
        ef = efp[1:] + k*ebp[1:]
        ebp = ebp[:-1] + k*efp[:-1]
        efp = ef.copy()

        # Update the AR coeff
        a[1:m+2] = a[1:m+2] + k*np.conj(a[m::-1])
        e = (1-k**2)*e

    return a,e,rc

def ipredict(x,ar,M,mode):
    N = len(x)
    p = len(ar)-1

    if mode == 'forward':
        y = np.append(x,np.zeros(M))
        for m in range(M):
            for k in range(p):
                y[N+m] = y[N+m] - y[N+m-k-1]*ar[k+1]
    elif mode == 'backward':
        y = np.append(np.zeros(M),x)
        for m in range(M):
            for k in range(p):
                y[M-1-m] = y[M-1-m] - y[M-m+k]*ar[k+1]
    elif mode == 'twosided':
        y = np.append(x,np.zeros(M))
        y = np.append(np.zeros(M),y)
        for m in range(M):
            for k in range(p):
                y[M-1-m] = y[M-1-m] - y[M-m+k]*ar[k+1]
                y[N+M+m] = y[N+M+m] - y[N+M+m-k-1]*ar[k+1]
    else:
        raise Exception("mode='forward'|'backward'|'twosided'")

    return y


#%%
fs = 500.
t = np.arange(0,10,1/fs)
x0 = np.cos(2*np.pi*t)+0.2*np.sin(2*np.pi*10*t)     # origin signal

p = 21                                              # prediction model order

N0 = len(x0)                                        # true data
N = int(N0*0.9)                                     # given data
M = N0-N                                            # points to be predicted

#%% forward prediction
x1 = x0[0:N].copy()
a1,_,_ = iarburg(x1,p)

y1 = ipredict(x1,a1,M,'forward')

plt.figure()
plt.subplot(2,1,1)
plt.plot(t,y1,label='iarburg')
plt.plot(t,x0,'--',label='real')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.ylabel('Signal')

plt.subplot(2,1,2)
plt.plot(t[N:],y1[N:]-x0[N:],label='iarburg')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.ylabel('Error')
plt.show()

#%% backward prediction
x2 = x0[-N:].copy()

a2,_,_ = iarburg(x2,p)
y21 = ipredict(x2,a2,M,'backward')

# prediction with reversed data
x2t = x2[::-1].copy()
a2t,_,_ = iarburg(x2t,p)
y22 = ipredict(x2t,a2t,M,'forward')
y22 = y22[::-1]

plt.figure()
plt.subplot(2,1,1)
plt.plot(t,y21,label='iarburg')
plt.plot(t,y22,label='reversed-arburg')
plt.plot(t,x0,'--',label='real')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.ylabel('Signal')

plt.subplot(2,1,2)
plt.plot(t[:M],y21[:M]-x0[:M],label='iarburg')
plt.plot(t[:M],y22[:M]-x0[:M],label='reversed-arburg')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.ylabel('Error')
plt.show()

#%% twosided prediction to cancel transient dynamic in filtering
Nf,Wn = sig.ellipord(3/(fs/2),5/(fs/2),1,40)
b,a = sig.ellip(Nf,1,40,Wn)

x1 = sig.filtfilt(b,a,x0)

ar,_,_ = iarburg(x0,p)
xx = ipredict(x0,ar,M,'twosided')
x2 = sig.filtfilt(b,a,xx)
x2 = x2[M:N0+M]

plt.figure()
plt.plot(t,x1,label='direct filter')
plt.plot(t,x2,label='extended filter')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.ylabel('Signal')
plt.show()