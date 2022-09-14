% 观察不同频率采样引起的栅栏效应：
%    测试采用周期图法，通过设定不同频点数进行对比。

% XiaoCY 2020-10-21

%%
clear;clc
close all

%% 构造单频信号
fs = 100;
fsig1 = 1;
fsig2 = 1.001;
T = 1000;
N = T*fs;

t = (0:N-1)'/fs;
x1 = sin(2*pi*fsig1*t);
x2 = sin(2*pi*fsig2*t);
x = x1+x2;

figure('Name','Sine')
plot(t,x1)
hold on
grid on
plot(t,x2)
xlabel('Time (s)')
ylabel('Value')
xlim([0 10])

%% 不同频率点计算PSD
win = rectwin(N);
df = 0.003;

figure('Name','PSD')
[pxx,f] = periodogram(x,win,N*100,fs,'onesided');
plot(f,sqrt(pxx),'DisplayName','DTFT')
hold on
grid on
legend
xlim([fsig1-df fsig2+df])
xlabel('Frequency (Hz)')
ylabel('Power Spectrum')

%%
markersize = 25;
[pxx,f] = periodogram(x,win,N/2,fs,'onesided');
plot(f,sqrt(pxx),'DisplayName','nfft/2',...
    'Marker','.','MarkerSize',markersize,'LineStyle','none')
legend

%%
[pxx,f] = periodogram(x,win,N,fs,'onesided');
plot(f,sqrt(pxx),'DisplayName','nfft',...
    'Marker','.','MarkerSize',markersize,'LineStyle','none')
legend

%%
[pxx,f] = periodogram(x,win,N*5,fs,'onesided');
plot(f,sqrt(pxx),'DisplayName','5nfft',...
    'Marker','.','MarkerSize',markersize,'LineStyle','none')
legend