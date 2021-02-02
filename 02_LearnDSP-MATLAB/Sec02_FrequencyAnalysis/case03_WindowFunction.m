% Compare different window functions to estimate spectrum
% Key: the coefficient to normalize the spectrum

% XiaoCY 2021-02-02

%% single frequency signal
clear;clc

fs = 1000;                          % sampling frequency
fsig = 100;                         % signal frequency

t = (0:1/fs:100/fsig)';             % time series
N = length(t);                      % number of samples

x = cos(2*pi*fsig*t);

Nf = floor(N/2);                    % number of frequency points
f = (0:Nf)'*fs/N;

%% rectangular window
X = fft(x);
amp = abs(X(1:Nf+1))*2/N;           % ATTENTION to the 'N' in the denominator

figure('NumberTitle',1,'Name','spectrum')
plot(f,amp,'DisplayName','rectwin')
hold on
grid on
legend
xlabel('Frequency (Hz)')
ylabel('Amplitude')

%% hanning window
win = hanning(N);
X = fft(x.*win);
amp = abs(X(1:Nf+1))*2/sum(win);    % 'N' is actually the sum of the window

figure(1)
plot(f,amp,'DisplayName','hanning')
hold on
grid on
legend
xlabel('Frequency (Hz)')
ylabel('Amplitude')

%% hanning window
win = hamming(N);
X = fft(x.*win);
amp = abs(X(1:Nf+1))*2/sum(win);

figure(1)
plot(f,amp,'DisplayName','hamming')
hold on
grid on
legend
xlabel('Frequency (Hz)')
ylabel('Amplitude')

%% blackmanharris window
win = blackmanharris(N);
X = fft(x.*win);
amp = abs(X(1:Nf+1))*2/sum(win);

figure(1)
plot(f,amp,'DisplayName','blackmanharris')
hold on
grid on
legend
xlabel('Frequency (Hz)')
ylabel('Amplitude')
xlim([80 120])