% Estimate PSD with nonparametric methods

% XiaoCY 2021-02-24

%%
clear;clc

fs = 1000;                  % sampling frequency (Hz)
Wp = 30/(fs/2);             % passband corner frequency (normalized)
Ws = 50/(fs/2);             % stopband corner frequency (normalized)
Rp = 1;                     % passband ripple (dB)
Rs = 40;                    % stopband attenuation (dB)

[n,Wn] = cheb2ord(Wp,Ws,Rp,Rs);
[b,a] = cheby2(n,Rs,Wn);
x = randn(round(10*fs),1)*sqrt(fs/2);
x = filter(b,a,x);

%% periodogram
N = length(x);
nfft = N;
win = hanning(N);
[px1,f1] = periodogram(x,win,nfft,fs,'onesided');

%% pmtm
[px2,f2] = pmtm(x,4,N,fs,'onesided');

%% pwelch
nfft = round(N/5);
win = hanning(nfft);
noverlap = round(nfft*0.6);
[px3,f3] = pwelch(x,win,noverlap,nfft,fs,'onesided');

%% results
h = freqz(b,a,f1,fs);

figure
loglog(f1,sqrt(px1),'DisplayName','periodogram')
hold on
grid on
loglog(f2,sqrt(px2),'DisplayName','pmtm')
loglog(f3,sqrt(px3),'DisplayName','pwelch')
loglog(f1,abs(h),'--','DisplayName','true PSD')
legend
xlabel('Frequency (Hz)')
ylabel('PSD')