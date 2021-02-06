'''
Personal fuction library in Python
Contents
    (1) pxx,f = lpsd(data,fs,Jdes=1000)

Last Update: 2021-02-06
'''

# %%
import numpy as np
import matplotlib.pyplot as plt

# %% function01: LPSD
'''
LPSD: Logarithmic frequency axis Power Spectral Density
pxx,f = lpsd(data,fs,Jdes=1000)
   data --- Input data series, one dimension vector
   fs   --- Sample frequency, unit: Hz
   Jdes --- Desired frequency points, default: 1000
   pxx  --- One-sided PSD, unit: *^2/Hz
   f    --- Frequency points related to PSD points, unit: Hz
   Default window function is hanning window.

Ref: Improved spectrum estimation from digitized time series on a logarithmic frequency axis
     Article DOI: 10.1016/j.measurement.2005.10.010

Remark: Unfamiliar with Python by now, the function doesn't support matrix data by now.
    [MATLAB version supports matrix data.]

XiaoCY 2021-02-06
'''

# subfuction
# calculate frequency points
def getFreqs(N,fs,Jdes,Kdes,ksai):
    fmin = fs/N
    fmax = fs/2
    r_avg = fs/N*(1+(1-ksai)*(Kdes-1))

    g = (N/2)**(1/(Jdes-1))-1

    f = np.zeros(Jdes)-1
    L = np.copy(f)
    m = np.copy(f)
    j = 0
    fj = fmin
    while fj < fmax:
        rj = fj*g
        if rj < r_avg:
            rj = np.sqrt(rj*r_avg)
        if rj < fmin:
            rj = fmin
        
        Lj = np.floor(fs/rj)
        rj = fs/Lj
        mj = fj/rj

        f[j] = fj
        L[j] = Lj
        m[j] = mj

        fj = fj+rj
        j += 1
    
    idx = f<0
    f = np.delete(f,idx)
    L = np.delete(L,idx)
    m = np.delete(m,idx)
    return f,L,m

# main
def lpsd(data,fs,Jdes=1000):
    Kdes = 100
    ksai = 0.5
    N = len(data)

    f,L,m = getFreqs(N,fs,Jdes,Kdes,ksai)

    J = len(f)
    pxx = np.zeros(J)
    for j in range(J):
        Dj = int(np.floor((1-ksai)*L[j]))
        Kj = int(np.floor((N-L[j])/Dj+1))
        w = np.hanning(L[j])
        C_PSD = 2/fs/np.dot(w,w)
        l = np.arange(0,L[j])
        W1 = np.cos(-2*np.pi*m[j]/L[j]*l)
        W2 = np.sin(-2*np.pi*m[j]/L[j]*l)
        A = 0.
        for k in range(Kj-1):
            G = data[k*Dj:k*Dj+int(L[j])].copy()
            G = G-np.mean(G)
            G = G*w
            A += np.dot(G,W1)**2 + np.dot(G,W2)**2
        pxx[j] = A/Kj*C_PSD

    return pxx,f