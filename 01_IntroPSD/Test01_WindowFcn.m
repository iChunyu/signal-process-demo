% 测试窗函数对功率谱估计的影响：
%    1. 测试不同窗函数对单频信号功率谱估计的效果：主瓣宽度对频率分辨率的影响；
%    2. 在单频信号下加入较小的白噪声，观察白噪声谱密度受频率泄漏的影响。
% 为了窗函数应用的方便，测试时PSD绘制采用周期图法。

% XiaoCY 2020-10-21

%%
clear;clc
close all

%% 单频信号加窗测试
fs = 1000;
T = 10;
t = (0:1/fs:T)';

fsig = 50;
sig = sin(2*pi*fsig*t);

nfft = length(sig);
win_rect = rectwin(nfft);
win_hann = hann(nfft);
win_bh = blackmanharris(nfft);
wvtool(win_rect,win_hann,win_bh)

set(groot,'DefaultFigureWindowStyle','docked')
figure('Name','SignalPSD')
[px_rect,f] = periodogram(sig,win_rect,nfft,fs,'onesided');
loglog(f,sqrt(px_rect),'DisplayName','RecWin')
hold on
grid on
[px_hann,f] = periodogram(sig,win_hann,'onesided',nfft,fs);
loglog(f,sqrt(px_hann),'DisplayName','HanWin')
[px_bh,f] = periodogram(sig,win_bh,'onesided',nfft,fs);
loglog(f,sqrt(px_bh),'DisplayName','BHWin')
legend
xlabel('Frequency (Hz)')
ylabel('Power Spectrum (V/Hz^{1/2})')

%% 频谱泄漏对功率谱估计的影响
PSD = 1e-4;
xn = randn(size(sig))*PSD*sqrt(fs/2);
new_sig = sig+xn;

figure('Name','NoisePSD')
[px_rect,f] = periodogram(new_sig,win_rect,nfft,fs,'onesided');
loglog(f,sqrt(px_rect),'DisplayName','RecWin')
hold on
grid on
[px_hann,f] = periodogram(new_sig,win_hann,nfft,fs,'onesided');
loglog(f,sqrt(px_hann),'DisplayName','HanWin')
[px_bh,f] = periodogram(new_sig,win_bh,nfft,fs,'onesided');
loglog(f,sqrt(px_bh),'DisplayName','BHWin')
legend
xlabel('Frequency (Hz)')
ylabel('Power Spectrum (V/Hz^{1/2})')