% Estimate filter response using white noise
% Use PSD to identify system
% 
% XiaoCY 2021-02-09

%%
clear;clc

fs = 1000;                  % sampling frequency (Hz)
Wp = 30/(fs/2);             % passband corner frequency (normalized)
Ws = 50/(fs/2);             % stopband corner frequency (normalized)
Rp = 1;                     % passband ripple (dB)
Rs = 40;                    % stopband attenuation (dB)

[n,Wn] = ellipord(Wp,Ws,Rp,Rs);
[b,a] = ellip(n,Rp,Rs,Wn);

%%
u = randn(round(10*fs),1)*sqrt(fs/2);
x = filter(b,a,u);

[pxx,f] = iLPSD(x,fs);
h = freqz(b,a,f,fs);

figure
loglog(f,sqrt(pxx),'DisplayName','PSD')
grid on
hold on
loglog(f,abs(h),'--','DisplayName','Filter')
legend
xlabel('Frequency (Hz)')
ylabel('Gain')