% Generate random signal with given PSD

% XiaoCY 2021-02-24

%%
clear;clc

fs = 1e3;
L = 5e3;                            % frequency length (excluding DC)
N = 2*L+1;                          % data length
f = (1:L)'*fs/N;                    % one-sided frequency

S = 3+exp(-(f-250).^2/2/30^2);      % square root of one-sided PSD (common used)

%%
A = S*sqrt(N*fs);                   % abs(X)
phi = randn(L,1)*pi;                % random phase
X1 = A.*exp(1j*phi);
X = [0+0j; X1; conj(X1)];           % two-sided FFT
x = ifft(X);
x = real(x);

%%
t = (0:N-1)/fs;

figure('Name','signal')
plot(t,x)
grid on
xlabel('Time (s)')
ylabel('Signal')


nfft = round(N/10);
win = hanning(nfft);
noverlap = round(nfft*0.8);
[pxx,fx] = pwelch(x,win,noverlap,nfft,fs,'onesided');

figure('Name','PSD')
plot(fx,sqrt(pxx),'DisplayName','generated')
hold on
grid on
plot(f,S,'DisplayName','target')
legend
xlabel('Frequency (Hz)')
ylabel('PSD')