% Compare normal IIR filtering with zero-phase filtering
% Use digital filter

% XiaoCY 2021-02-18

%%
clear;clc

fs = 500;
t = (0:1/fs:5);
x0 = cos(2*pi*t)+0.2*sin(2*pi*10*t);

%%
[N,Wn] = ellipord(3/(fs/2),5/(fs/2),1,40);
[b,a] = ellip(N,1,40,Wn);

x1 = filter(b,a,x0);
x2 = filtfilt(b,a,x0);

figure()
plot(t,x0,'DisplayName','origin')
hold on
grid on
plot(t,x1,'DisplayName','filter')
plot(t,x2,'DisplayName','filtflit')
legend
xlabel('Time (s)')
ylabel('Signal')
