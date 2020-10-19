% 测试窗函数对功率谱估计的影响

%%
set(groot,'DefaultLineLineWidth',2)
set(groot,'DefaultAxesFontSize',20)
set(groot,'DefaultFigureColor','w')

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

figure('Name','SignalPSD')
[px_rect,f] = periodogram(sig,win_rect,'onesided',nfft,fs);
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
[px_rect,f] = periodogram(new_sig,win_rect,'onesided',nfft,fs);
loglog(f,sqrt(px_rect),'DisplayName','RecWin')
hold on
grid on
[px_hann,f] = periodogram(new_sig,win_hann,'onesided',nfft,fs);
loglog(f,sqrt(px_hann),'DisplayName','HanWin')
[px_bh,f] = periodogram(new_sig,win_bh,'onesided',nfft,fs);
loglog(f,sqrt(px_bh),'DisplayName','BHWin')
legend
xlabel('Frequency (Hz)')
ylabel('Power Spectrum (V/Hz^{1/2})')