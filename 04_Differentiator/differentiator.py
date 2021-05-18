# Compare properties of differentiators:
#   1. numerical difference;
#   2. analog differentiators:
#      2.1 use one low-pass filter;
#      2.2 use two low-pass filters;
#   3. tracking differentiator

# XiaoCY 2021-05-18

# %% signal
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as signal
from springlib import lpsd

pi = np.pi

fs = 200.0
T = 100.0
Ts = 1.0/fs

t = np.arange(0,T,Ts)
x0 = 5.0*np.sin(2.0*pi*t)
y0 = 10.0*pi*np.cos(2.0*pi*t)
K = len(t)
xn = np.random.randn(K)
x = x0+xn

plt.figure()
plt.plot(t,x,label='data')
plt.plot(t,x0,label='signal')
plt.plot(t,xn,label='noise')
plt.legend()
plt.grid()
plt.xlabel('Time (s)')
plt.xlim(0,10)
plt.show()

# %% numerical difference
y1 = np.diff(x)/Ts
t1 = t[1:]

[b,a] = signal.butter(2.0, 5.0/(fs/2.0))
y1f = signal.lfilter(b,a,y1)

plt.figure()
plt.plot(t1,y1,label='numerical difference')
plt.plot(t1,y1f,label='filtered difference')
plt.plot(t,y0,label='real derivaticve')
plt.legend(loc='upper right')
plt.grid()
plt.xlabel('Time (s)')
plt.xlim(0,10)
plt.ylim(-700,700)
plt.show()

plt.figure()
px,fx = lpsd(x,fs)
py1,_ = lpsd(y1,fs)
py1f,f1 = lpsd(y1f,fs)
plt.loglog(fx,np.sqrt(px),label='original data')
plt.loglog(f1,np.sqrt(py1),label='numerical difference')
plt.loglog(f1,np.sqrt(py1f),label='filtered difference')
plt.legend(loc='upper left')
plt.grid()
plt.xlabel('Frequency (Hz)')
plt.ylabel('PSD')
plt.ylim(1e-3,1e2)
plt.show()

# %% analog differentiator (given by numerical simulation)
T1 = 5.0*Ts
sys1 = signal.TransferFunction([1,0],[T1,1])
_,y21,_ = signal.lsim(sys1,x,t)

T2 = 10.0*Ts
sys2 = signal.TransferFunction([1, 0], [T1*T2, T1+T2, 1])
_,y22,_ = signal.lsim(sys2,x,t)

plt.figure()
plt.plot(t,y21,label='use one LPF')
plt.plot(t,y22,label='use two LPFs')
plt.plot(t,y0,label='real derivaticve')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.xlim(0,10)
plt.show()

py21,_ = lpsd(y21,fs)
py22,f2 = lpsd(y22,fs)
plt.figure()
plt.loglog(fx,np.sqrt(px),label='original data')
plt.loglog(f1,np.sqrt(py21),label='use one LPF')
plt.loglog(f1,np.sqrt(py22),label='use two LPFs')
plt.legend(loc='upper left')
plt.grid()
plt.xlabel('Frequency (Hz)')
plt.ylabel('PSD')
plt.ylim(1e-3,1e2)
plt.show()

# %% tracking differentiator
h = 10.0*Ts
r = (2.0*pi*10.0/1.44)**2           # approximation: wc = 1.14*sqrt(r)
d = r*h**2

x1 = x2 = 0
y3 = np.zeros(K)
for k in range(K):
    # fhan: p107, E.q.(2.7.24)
    a0 = h*x2
    y = x1-x[k]+a0
    a1 = np.sqrt(d*(d+8*abs(y)))
    a2 = a0+np.sign(y)*(a1-d)/2
    sy = (np.sign(y+d)-np.sign(y-d))/2
    a = (a0+y-a2)*sy+a2
    sa = (np.sign(a+d)-np.sign(a-d))/2
    fhan = -r*(a/d-np.sign(a))*sa-r*np.sign(a)
    
    x2 = x2+fhan*Ts
    x1 = x1+x2*Ts
    
    y3[k] = x2

plt.figure()
plt.plot(t,y3,label='tracking differentiator')
plt.plot(t,y0,label='real derivaticve')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.xlim(0,10)
plt.show()

py3,f3 = lpsd(y3,fs)
plt.figure()
plt.loglog(fx,np.sqrt(px),label='original data')
plt.loglog(f1,np.sqrt(py3),label='tracking differentiator')
plt.legend(loc='upper left')
plt.grid()
plt.xlabel('Frequency (Hz)')
plt.ylabel('PSD')
plt.ylim(1e-3,1e2)
plt.show()

# %%
plt.figure()
plt.plot(t1,y1f,label='filtered difference')
plt.plot(t,y21,label='use one LPF')
plt.plot(t,y22,label='use two LPFs')
plt.plot(t,y3,label='tracking differentiator')
plt.plot(t,y0,label='real derivaticve')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.xlim(0,10)
plt.show()

plt.figure()
plt.loglog(f1,np.sqrt(py1),label='numerical difference')
plt.loglog(f1,np.sqrt(py1f),label='filtered difference')
plt.loglog(f1,np.sqrt(py21),label='use one LPF')
plt.loglog(f1,np.sqrt(py22),label='use two LPFs')
plt.loglog(f1,np.sqrt(py3),label='tracking differentiator')
plt.legend(loc='upper left')
plt.grid()
plt.xlabel('Frequency (Hz)')
plt.ylabel('PSD')
plt.ylim(1e-3,1e2)
plt.show()