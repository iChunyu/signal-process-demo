% Use built-in functions to design FIR filter
%   1) Window-based FIR filter design
%   2) Frequency sampling-based FIR filter design
% Band-pass filter for example

% XiaoCY 2021-02-08

%%
clear;clc

fs = 100;                               % sampling frequency (Hz)
fsig = 3;                               % signal frequency (Hz)

fn = [ fsig/3, fsig*3];
Wn = fn/(fs/2);
N = 100;

t = (0:1/fs:10/fsig)';
x0 = sin(2*pi*fsig*t);
xn = randn(size(x0))*0.3;
x = x0+xn;

f = linspace(0,fsig*10,500);

%% FIR design
% Window-based FIR filter design
b1 = fir1(N,Wn);
h1 = freqz(b1,1,f,fs);
x1 = filtfilt(b1,1,x);

% Frequency sampling-based FIR filter design
freq = [0 fsig/4 fsig/3 fsig fsig*3 fsig*4 fs/2]/(fs/2);
mreq = [0 0 1 1 1 0 0];
b2 = fir2(N,freq,mreq);
h2 = freqz(b2,1,f,fs);
x2 = filtfilt(b2,1,x);

%% Results
figure('Name','filter')
plot(f,abs(h1),'DisplayName','fir1')
hold on
grid on
plot(f,abs(h2),'DisplayName','fir2')
legend
xlabel('Frequency (Hz)')
ylabel('Gain')

figure('Name','data')
plot(t,x,'DisplayName','origin')
grid on
hold on
plot(t,x1,'DisplayName','fir1')
plot(t,x2,'DisplayName','fir2')
plot(t,x0,'--','DisplayName','real')
legend
xlabel('Time (s)')
ylabel('Signal')