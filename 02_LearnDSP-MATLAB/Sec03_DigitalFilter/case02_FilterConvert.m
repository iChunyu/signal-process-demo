% Analog-to-digital filter conversion
%   1. Impulse invariance method
%   2. Bilinear transformation method
% 
% XiaoCY 2021-02-07

%%
clear;clc

fs = 10;                            % sampling frequency (Hz)
fc = 1;                             % corner frequency (Hz)
[b,a] = butter(2,2*pi*fc,'s');     	% demo transfer function to be converted

%% Filter conversion
% Impulse invariance method
[bz1,az1] = impinvar(b,a,fs);

% Bilinear transformation method
[bz2,az2] = bilinear(b,a,fs);

% summary
f = linspace(0,fs,500);
h = freqs(b,a,f*2*pi);
h1 = freqz(bz1,az1,f,fs);
h2 = freqz(bz2,az2,f,fs);

figure
plot(f,abs(h))
grid on
hold on
plot(f,abs(h1))
plot(f,abs(h2))
xline(fs/2,'--','fs/2',...
    'LabelHorizontalAlignment','center',...
    'LabelVerticalAlignment','middle')
legend('analog','impinvar','bilinear','Location','north')
xlabel('Frequency (Hz)')
ylabel('Gain')