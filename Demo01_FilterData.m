% 功率谱估计可以用于评估仪器噪声在频带内的分布，为数据滤波提供依据
% 示例数据说明：
%    test-data-01 --- 假设的某录音设备噪声本底
%    test-data-02 --- 上述录音设备录制的某音频

%%
set(groot,'DefaultLineLineWidth',2)
set(groot,'DefaultAxesFontSize',20)
set(groot,'DefaultFigureColor','w')

clear;clc
close all

%% 导入噪声本底数据
load('test-data-01.mat')

figure('Name','Noise')
plot(xn)
grid on
xlabel('Sample')
ylabel('Noise (V)')

nfft = length(xn);
win = hanning(nfft);
[pxn,f] = periodogram(xn,win,'onesided',nfft,fs);

figure('Name','NoisePSD')
loglog(f,sqrt(pxn),'DisplayName','NoiseFloor')
grid on
legend
xlabel('Frequency (Hz)')
ylabel('Power Spectrum (V/Hz^{1/2})')

%% 导入录音数据
load('test-data-02.mat')

figure('Name','Data')
plot(data)
grid on
xlabel('Sample')
ylabel('Raw Data (V)')

[pdat,f] = periodogram(data,win,'onesided',nfft,fs);

figure('Name','DataPSD')
loglog(f,sqrt(pxn),'DisplayName','NoiseFloor')
hold on
grid on
loglog(f,sqrt(pdat),'DisplayName','Data')
legend
xlabel('Frequency (Hz)')
ylabel('Power Spectrum (V/Hz^{1/2})')

% sound(data,fs)

%% 滤波
filter_data = bandpass(data,[20 1500],fs);

figure('Name','Data')
plot(filter_data)
grid on
xlabel('Sample')
ylabel('Filtered Data (V)')

[pfilt,f] = periodogram(filter_data,win,'onesided',nfft,fs);

figure('Name','DataPSD')
loglog(f,sqrt(pxn),'DisplayName','NoiseFloor')
hold on
grid on
loglog(f,sqrt(pdat),'DisplayName','Data')
loglog(f,sqrt(pfilt),'DisplayName','FilteredData')
legend
xlabel('Frequency (Hz)')
ylabel('Power Spectrum (V/Hz^{1/2})')

% sound(filter_data,fs)