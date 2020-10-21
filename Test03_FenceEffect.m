% 观察不同频率采样引起的栅栏效应：
%    测试采用周期图法，通过设定不同频点数进行对比。

% XiaoCY 2020-10-21

%%
set(groot,'DefaultLineLineWidth',2)
set(groot,'DefaultAxesFontSize',20)
set(groot,'DefaultFigureColor','w')
set(groot,'DefaultFigureWindowStyle','docked')

clear;clc
close all

%% 构造单频信号
fs = 100;
fsig = 1;
T = 1000;
N = T*fs;

t = (0:N-1)'/fs;
x = sin(2*pi*fsig*t);

figure('Name','Sine')
plot(t,x)
grid on
xlabel('Time (s)')
ylabel('Value')
xlim([0 5])

%% 不同频率点计算PSD
win = rectwin(N);
df = 0.005;

figure('Name','PSD')
[pxx,f] = periodogram(x,win,N*100,fs,'onesided');
plot(f,sqrt(pxx),'DisplayName','DTFT')
hold on
grid on
legend
xlim([fsig-df fsig+df])
xlabel('Frequency (Hz)')
ylabel('Power Spectrum')

%%
markersize = 30;
[pxx,f] = periodogram(x,win,N*10,fs,'onesided');
plot(f,sqrt(pxx),'DisplayName','10nfft',...
    'Marker','.','MarkerSize',markersize,'LineStyle','none')
legend

%%
[pxx,f] = periodogram(x,win,5*N,fs,'onesided');
plot(f,sqrt(pxx),'DisplayName','nfft',...
    'Marker','.','MarkerSize',markersize,'LineStyle','none')
legend

%%
[pxx,f] = periodogram(x,win,N/2,fs,'onesided');
plot(f,sqrt(pxx),'DisplayName','nfft/2',...
    'Marker','.','MarkerSize',markersize,'LineStyle','none')
legend