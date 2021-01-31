% 功率谱用于检测噪声中的单频信号

% XiaoCY 2020-10-21

%%
set(groot,'DefaultLineLineWidth',2)
set(groot,'DefaultAxesFontSize',20)
set(groot,'DefaultFigureColor','w')
set(groot,'DefaultFigureWindowStyle','docked')

clear;clc
close all

%% 构造噪声信号
fs = 1e3;
T = 100;
N = T*fs;

t = (0:N-1)'/fs;
x = 10*sin(2*pi*10*t)+0.5*cos(2*pi*50*t);
xn = randn(N,1)*1e-2*sqrt(fs/2);

sig = x+xn;

figure('Name','Signal')
plot(t,sig)
grid on
xlim([0 1])
xlabel('Time (s)')
ylabel('Signal')

%%
figure('Name','PSD')
iLPSD(sig,fs)

%%
aFit = fittype({'1','sin(2*pi*10*x)','cos(2*pi*10*x)',...
    'sin(2*pi*50*x)','cos(2*pi*50*x)'});
[fobj,gobj] = fit(t,x,aFit);
disp(fobj)
disp(gobj)
sig_fit = feval(cfit(fobj),t);

figure('Name','Fit')
plot(t,sig,'DisplayName','Origin')
grid on
hold on
plot(t,sig_fit,'DisplayName','Fit')
xlim([0 1])
legend
xlabel('Time (s)')
ylabel('Signal')