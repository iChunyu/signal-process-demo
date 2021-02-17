'''
Smooth data

XiaoCY 2021-02-15
'''

#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as signal
import springlib as sp

fs = 100.
t = np.arange(0,20,1/fs)
x0 = np.cos(2*np.pi*t)
xn = np.random.randn(len(t))*0.2
x = x0+xn

#%% five-spot triple smoothing method
m = 21                          # smooth times

a = x.copy()
y1 = x.copy()
N = len(x)
for k in range(m):
    y1[0] = (69*a[0] + 4*(a[1]+a[3]) - 6*a[2] - a[4])/70
    y1[1] = (2*(a[0]+a[4]) + 27*a[1] + 12*a[2] - 8*a[3])/35
    for j in range(2,N-2):
        y1[j] = (-3*(a[j-2]+a[j+2]) + 12*(a[j-1]+a[j+1]) + 17*a[j])/35
    y1[N-2] = (2*(a[N-5]+a[N-1]) - 8*a[N-4] + 12*a[N-3] + 27*a[N-2])/35
    y1[N-1] = (-a[N-5] + 4*(a[N-4]+a[N-2]) - 6*a[N-3] + 69*a[N-1])/70
    a = y1.copy()

#%% built-in function
# No `smooth` function in Python
y3 = signal.savgol_filter(x,21,5)

#%%
plt.figure()
plt.plot(t,x)
plt.plot(t,y1)
plt.plot(t,y3)
plt.grid()
plt.legend(('origin','mean53('+str(m)+')','Savitzky-Golay'))
plt.xlabel('Time (s)')
plt.ylabel('Signal')
plt.show()

px,f = sp.lpsd(x,fs)
py1,_ = sp.lpsd(y1,fs)
py3,_ = sp.lpsd(y3,fs)
plt.figure()
plt.loglog(f,np.sqrt(px))
plt.loglog(f,np.sqrt(py1))
plt.loglog(f,np.sqrt(py3))
plt.grid()
plt.legend(('origin','mean53('+str(m)+')','Savitzky-Golay'))
plt.xlabel('Frequency (Hz)')
plt.ylabel('PSD')
plt.show()