% 功率谱估计用于系统辨识

% XiaoCY 2020-10-21

%%
set(groot,'DefaultLineLineWidth',2)
set(groot,'DefaultAxesFontSize',20)
set(groot,'DefaultFigureColor','w')
set(groot,'DefaultFigureWindowStyle','docked')

clear;clc
close all

%% 构造待测系统和单位白噪声
sys = tf(6,[1 2 6]);

fs = 10;
T = 5e3;
N = T*fs;

for k = 1:5
    t = (0:N-1)'/fs;
    xn = randn(N,1)*sqrt(fs/2);
    
    y = lsim(sys,xn,t);
    [pxx,f] = iLPSD(y,fs);
    
    [A,~,~] = bode(sys,2*pi*f);
    A = squeeze(A);
    
    figure('Name','Identify')
    loglog(f,sqrt(pxx),'DisplayName','Identified')
    grid on
    hold on
    loglog(f,A,'DisplayName','Real')
    legend
    xlabel('Frequency (Hz)')
end
ylabel('Gain')