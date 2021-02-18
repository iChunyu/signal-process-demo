'''
Main code for DSP project
(See ../DSP_Project_Reqirement&Guidance(2020 Fall).pdf Project-1 for detail.)

XiaoCY 2021-02-18
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as signal
import springlib as sp

savepdf = False
N = 1000
fs = 1000.0
pi = np.pi

t = np.arange(N)/fs
x1 = np.cos(2*pi*50*t)
x2 = 0.3*np.cos(2*pi*100*t + pi/3)
x3 = 0.2*np.cos(2*pi*150*t - pi/3)
x4 = 0.1*np.sin(2*pi*250*t)
xn = 0.05*np.random.randn(N)
x = x1+x2+x3+x4+xn

#%% design IIR filter
Wp = 110./(fs/2)             # passband corner frequency (normalized)
Ws = 130./(fs/2)             # stopband corner frequency (normalized)
Rp = 1.                      # passband ripple (dB)
Rs = 60.                     # stopband attenuation (dB)

Nz,Wn = signal.cheb2ord(Wp,Ws,Rp,Rs)
b,a = signal.cheby2(Nz,Rs,Wn)

f = np.linspace(0,fs/2,500)
_,g = signal.freqz(b,a,f,fs=fs)
gdb = 20*np.log10(np.abs(g))

plt.figure()
plt.plot(f,gdb,label='Chebyshev Type II')
plt.grid()
plt.legend()
plt.xlabel('Frequency (Hz)')
plt.ylabel('Gain (dB)')
plt.xlim(0,fs/2)
if savepdf: 
    plt.savefig('prjFilter.pdf')
plt.show()

#%% filter data
y = signal.filtfilt(b,a,x)

plt.figure()
plt.plot(t,x,label='original')
plt.plot(t,y,label='filtered')
plt.grid()
plt.legend()
plt.xlabel('Time (s)')
plt.ylabel('Signal (A)')
plt.xlim(0,0.2)
if savepdf:
    plt.savefig('prjSignal.pdf')
plt.show()


pxx,fx = sp.lpsd(x,fs)
pyy,fy = sp.lpsd(y,fs)

plt.figure()
plt.semilogy(fx,np.sqrt(pxx),label='original')
plt.semilogy(fy,np.sqrt(pyy),label='filtered')
plt.grid()
plt.legend()
plt.xlabel('Frequency (Hz)')
plt.ylabel(r'Signal ($\rm A/\sqrt{Hz}$)')
if savepdf:
    plt.savefig('prjPSD.pdf')
plt.show()