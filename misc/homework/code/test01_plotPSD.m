% Compare estimated PSD with different methods

% XiaoCY 2021-02-18

%%
clear;clc

fs = 1000;                  % sampling frequency (Hz)
Wp = 30/(fs/2);             % passband corner frequency (normalized)
Ws = 50/(fs/2);             % stopband corner frequency (normalized)
Rp = 1;                     % passband ripple (dB)
Rs = 40;                    % stopband attenuation (dB)

[n,Wn] = ellipord(Wp,Ws,Rp,Rs);
[b,a] = ellip(n,Rp,Rs,Wn);

u = randn(10*fs,1)*sqrt(fs/2);
x = filter(b,a,u);

%%
N1 = length(x);
[px1,f1] = periodogram(x,hanning(N1),N1,fs,'onesided');

N2 = floor(N1/5);
[px2,f2] = pwelch(x,hann(N2),floor(N2/2),N2,fs);

[px3,f3] = iLPSD(x,fs);

h = freqz(b,a,f3,fs);

figure
loglog(f1,sqrt(px1),'DisplayName','Periodogram')
grid on
hold on
loglog(f2,sqrt(px2),'DisplayName','Welch')
loglog(f3,sqrt(px3),'DisplayName','LPSD')
loglog(f3,abs(h),'--','DisplayName','True PSD')
legend
xlabel('Frequency (Hz)')
ylabel('PSD')