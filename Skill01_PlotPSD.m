% 采用不同方法绘制功率谱
%    1. 周期图法：[pxx,f] = periodogram(data,window,nfft,fs,'onesided');
%    2. Welch法：[pxx,f] = pwelch(data,window,noverlap,nfft,fs,'onesided');
%    3. LPSD：[pxx,f] = iLPSD(data,fs);

% XiaoCY 2020-10-21

%%
set(groot,'DefaultLineLineWidth',2)
set(groot,'DefaultAxesFontSize',20)
set(groot,'DefaultFigureColor','w')
set(groot,'DefaultFigureWindowStyle','docked')

clear;clc
close all

%% 周期图法
load('gnd-noise.mat')

fprintf('%13s: ','Periodogram')
nfft = length(data);
window = hann(nfft);

tic
[pxx,f] = periodogram(data,window,nfft,fs,'onesided');
toc

figure('Name','PSD')
loglog(f,sqrt(pxx),'DisplayName','Periodogram')
hold on
grid on
legend
xlabel('Frequency (Hz)')
ylabel('Acceleration (m/s^2/Hz^{1/2})')

%% Welch法
fprintf('%13s: ','Welch')
nfft = round(length(data)/4);
window = hann(nfft);
noverlap = round(nfft/2);

tic
[pxx,f] = pwelch(data,window,noverlap,nfft,fs,'onesided');
toc

loglog(f,sqrt(pxx),'DisplayName','Welch')
legend

%% LPSD
fprintf('%13s: ','LPSD')

tic
[pxx,f] = iLPSD(data,fs);
toc

loglog(f,sqrt(pxx),'DisplayName','LPSD')
legend