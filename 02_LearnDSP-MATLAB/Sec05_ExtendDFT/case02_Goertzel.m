% Goertzel algorithm to calcudate DFT
% (iteration algorithm)
% PSD estimation in animation

% XiaoCY 2021-02-22

%%
clear;clc

% create time series
fs = 1000;                  % sampling frequency (Hz)
Wp = 30/(fs/2);             % passband corner frequency (normalized)
Ws = 50/(fs/2);             % stopband corner frequency (normalized)
Rp = 1;                     % passband ripple (dB)
Rs = 40;                    % stopband attenuation (dB)

[n,Wn] = ellipord(Wp,Ws,Rp,Rs);
[b,a] = ellip(n,Rp,Rs,Wn);
u = randn(round(10*fs),1)*sqrt(fs/2);
x = filter(b,a,u);

%%
N = length(x);
nfft = floor(N/2);
k = (1:nfft)';
W = exp(-1j*2*pi*k/N);
f = k*fs/N;

h = freqz(b,a,f,fs);
h = abs(h);

% initialize
X = zeros(nfft,1);
nFrame = 30;
dN = round(N/nFrame);
for k = 1:N
    X = x(k) + W.*X;
    
    if mod(k,dN) == 0
        P = abs(X)*sqrt(2/N/fs);
        loglog(f,P,f,h,'--');
        legend('real-time','true value')
        ylim([1e-4 1e1])
        grid on
        xlabel('Frequency (Hz)')
        ylabel('PSD')
        pause(0.2)
    end
end