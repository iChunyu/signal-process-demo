% Main code for DSP project
% (See ../DSP_Project_Reqirement&Guidance(2020 Fall).pdf Project-1 for detail.)

% XiaoCY 2021-02-18

%%
clear;clc

N = 1e3;
fs = 1e3;

t = (0:N-1)'/fs;
x1 = cos(2*pi*50*t);
x2 = 0.3*cos(2*pi*100*t + pi/3);
x3 = 0.2*cos(2*pi*150*t - pi/3);
x4 = 0.1*sin(2*pi*250*t);
xn = 0.05*randn(N,1);
x = x1+x2+x3+x4+xn;

%%
Wp = 110/(fs/2);                % passband corner frequency (normalized)
Ws = 130/(fs/2);                % stopband corner frequency (normalized)
Rp = 1;                         % passband ripple (dB)
Rs = 60;                        % stopband attenuation (dB)

[Nz,Wn] = cheb2ord(Wp,Ws,Rp,Rs);
[b,a] = cheby2(Nz,Rs,Wn);

f = linspace(0,fs/2,500);
g = freqz(b,a,f,fs);
gdb = 20*log10(abs(g));

figure('Name','filter')
plot(f,gdb,'DisplayName','Chebyshev Type II')
grid on
legend
xlabel('Frequency (Hz)')
ylabel('Gain (dB)')

%%
y = filtfilt(b,a,x);

figure('Name','time')
plot(t,x,'DisplayName','original')
hold on
grid on
plot(t,y,'DisplayName','filtered')
legend
xlabel('Time (s)')
ylabel('Signal (A)')
xlim([0,0.1])

figure('Name','PSD')
[pxx,f] = iLPSD([x,y],fs);
semilogy(f,sqrt(pxx))
grid on
legend('original','filtered')
xlabel('Frequency (Hz)')
ylabel('PSD (A/Hz^{1/2})')