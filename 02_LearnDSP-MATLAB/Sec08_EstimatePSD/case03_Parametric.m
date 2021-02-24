% Estimate PSD with parametric methods

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

%% pyulear
nfft = length(x);
p = 70;
[px1,f1] = pyulear(x,p,nfft,fs,'onesided');

%% pburg
[px2,f2] = pburg(x,p,nfft,fs,'onesided');

%% pcov
[px3,f3] = pcov(x,p,nfft,fs,'onesided');

%% pmcov
[px4,f4] = pmcov(x,p,nfft,fs,'onesided');

%% results
h = freqz(b,a,f1,fs);

figure
loglog(f1,sqrt(px1),'DisplayName','pyulear')
hold on
grid on
loglog(f2,sqrt(px2),'DisplayName','pburg')
loglog(f3,sqrt(px3),'DisplayName','pcov')
loglog(f4,sqrt(px4),'DisplayName','pmcov')
loglog(f1,abs(h),'--','DisplayName','true PSD')
legend
xlabel('Frequency (Hz)')
ylabel('PSD')