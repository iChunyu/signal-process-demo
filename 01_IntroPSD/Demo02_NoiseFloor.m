% 功率谱估计可以用于评估仪器噪声在频带内的分布，为数据滤波提供依据
% 示例数据说明：
%    test-noise --- 假设的某录音设备噪声本底
%    test-audio --- 上述录音设备录制的某音频
% 注释了sound函数避免自动播放声音导致音频重叠，手动播放。

% XiaoCY 2020-10-21

%%
clear;clc
close all

%% 导入噪声本底数据
load('test-noise.mat')

figure('Name','Noise')
plot(xn)
grid on
xlabel('Sample')
ylabel('Noise (V)')

nfft = length(xn);
win = hann(nfft);
[pxn,f] = periodogram(xn,win,'onesided',nfft,fs);

figure('Name','NoisePSD')
loglog(f,sqrt(pxn),'DisplayName','NoiseFloor')
grid on
legend
xlabel('Frequency (Hz)')
ylabel('Power Spectrum (V/Hz^{1/2})')

%% 导入录音数据
load('test-audio.mat')

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