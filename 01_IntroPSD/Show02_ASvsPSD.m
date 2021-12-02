% 对比幅度谱(AS)与功率谱密度(ASD,开方后)的区别

% XiaoCY 2021-12-02

%%
clear;clc
close all

%%
fs = 100;
N = 1e6;
t = (0:N-1)'/fs;

% singal
xs = 10*sin(2*pi*t);

% noise
xn = randn(N,1)*2e-1*sqrt(fs/2);

% sampled data
x = xs + xn;

figure(100)
plot(t,x)
grid on
xlabel('Time (s)')
ylabel('Voltage (V)')
xlim([0 10])



for Nk = round(N./[1 10 100])
    xk = x(1:Nk);
    [Xk,fk] = myfft(xk,fs);
    
    % Amplitude Spectrum
    figure(200)
    loglog(fk,2/Nk*Xk)
    hold on

    % Power Spectrum Density
    figure(300)
    loglog(fk,sqrt(2/Nk/fs)*Xk)
    hold on
end

figure(200)
grid on
xlabel('Frequency (Hz)')
ylabel('AS (V)')
title('Amplitude Spectrum')

figure(300)
grid on
xlabel('Frequency (Hz)')
ylabel('PSD  (V/Hz^{1/2})')
title('Power Spectrum Density')

%% subfunctions
function [X,f] = myfft(x,fs)
    Nx = length(x);
    fx = (0:Nx-1)'/Nx*fs;
    idx = fx <= fs/2;
    f = fx(idx);
    Xi = fft(x);
    X = abs(Xi(idx));
end