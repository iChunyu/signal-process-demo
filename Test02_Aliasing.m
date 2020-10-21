% 探究采样引入的频率混叠：
%    1. 构造低频信号，观察以不同倍数直接降采样引入的高频部分混叠；
%    2. 对比滤波后抽取与直接抽取的区别。
% 为了更容易看到混叠现象，测试时PSD绘制采用LPSD法。

% XiaoCY 2020-10-21

%%
set(groot,'DefaultLineLineWidth',2)
set(groot,'DefaultAxesFontSize',20)
set(groot,'DefaultFigureColor','w')
set(groot,'DefaultFigureWindowStyle','docked')

clear;clc
close all

%% 构造低通信号并展示其频谱，采样率1000Hz
fs = 1000;
T = 100;
N = T*fs;

x0 = randn(N,1)*sqrt(fs/2);
x0 = lowpass(x0,10,fs,'ImpulseResponse','iir','StopbandAttenuation',60);
[pxx,f] = iLPSD(x0,fs);

figure('Name','PSD')
loglog(f,sqrt(pxx),'DisplayName','Origin-1000Hz')
hold on
grid on
legend('location','southwest')
xlabel('Frequency (Hz)')
ylabel('Power Spectrum')

%% 10倍直接抽取，采样率降为100Hz
x1 = x0(1:10:end);
[pxx,f] = iLPSD(x1,fs/10);
loglog(f,sqrt(pxx),'DisplayName','Dedimate-100Hz')
legend('location','southwest')

%% 50倍直接抽取，采样率降为20Hz
x2 = x0(1:50:end);
[pxx,f] = iLPSD(x2,fs/50);
loglog(f,sqrt(pxx),'DisplayName','Dedimate-20Hz')
legend('location','southwest')

%% 100倍直接抽取，采样率为10Hz
x3 = x0(1:100:end);
[pxx,f] = iLPSD(x3,fs/100);
loglog(f,sqrt(pxx),'DisplayName','Dedimate-10Hz')
legend('location','southwest')

%% 抗混叠滤波后抽取，采样率为10Hz
x4 = lowpass(x0,4,fs,'ImpulseResponse','iir','StopbandAttenuation',60);
x4 = x4(1:100:end);
[pxx,f] = iLPSD(x4,fs/100);
loglog(f,sqrt(pxx),'DisplayName','Downsample-10Hz')
legend('location','southwest')