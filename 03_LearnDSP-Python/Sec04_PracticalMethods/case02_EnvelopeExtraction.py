'''
Extract envelope curve of a modulated signal
Use Hilbert transform

XiaoCY 
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig

fs = 100.
fsig = 1.

mu = 4.
b = mu/3.
t = np.arange(0,2*mu,1/fs)
evlp = np.exp(-(t-mu)**2/(2*b**2))
x = np.sin(2*np.pi*fsig*t)*evlp

#%% Hilbert Transform
y = sig.hilbert(x)

plt.figure()
ax = plt.axes(projection='3d')
ax.plot(t,x,label='signal')
ax.plot3D(t,y.real,y.imag,label='Hilbert')
ax.grid()
ax.legend()
ax.set_xlabel('Time (s)')
ax.set_ylabel('Re(H)')
ax.set_zlabel('Im(H)')
plt.show()

plt.figure
plt.plot(t,x,label='signal')
plt.plot(t,np.abs(y),label='Hilbert')
plt.plot(t,evlp,'--',label='envelope')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.ylabel('Signal')
plt.show()

#%% Transform with bias
bias = 1.
x1 = x+bias
evlp1 = evlp+bias

y1 = sig.hilbert(x1)
xm = np.mean(x1)
y2 = sig.hilbert(x1-xm)

plt.figure()
plt.plot(t,x1,label='signal')
plt.plot(t,np.abs(y1),label='direct Hilbert')
plt.plot(t,np.abs(y2)+xm,label='bias-cancelled ilbert')
plt.plot(t,evlp1,'--',label='envelope')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.ylabel('Signal')
plt.show()