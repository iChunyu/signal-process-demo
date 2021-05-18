% Compare properties of differentiators:
%   1. numerical difference;
%   2. analog differentiators:
%      2.1 use one low-pass filter;
%      2.2 use two low-pass filters;
%   3. tracking differentiator

% XiaoCY 2021-05-18

%% signal
clear;clc


fs = 200;
T = 100;
Ts = 1/fs;

t = (0:Ts:T)';
x0 = 5*sin(2*pi*t);
y0 = 10*pi*cos(2*pi*t);
xn = randn(size(x0))*sqrt(0.01*fs/2);
x = x0+xn;

figure
plot(t,x,'DisplayName','data')
hold on
grid on
plot(t,xn,'DisplayName','noise')
legend
xlabel('Time (s)')
ylabel('Signals')
xlim([0 10])

%% numerical difference
y1 = diff(x)/Ts;
t1 = t(1:end-1);

[b,a] = butter(2,5/(fs/2));
y1f = filter(b,a,y1);

figure
plot(t1,y1,'DisplayName','numerical difference')
hold on
grid on
plot(t1,y1f,'DisplayName','filtered difference')
plot(t,y0,'DisplayName','real derivaticve')
legend
xlabel('Time (s)')
xlim([0 10])

figure
iLPSD(x,fs)
hold on
iLPSD([y1 y1f],fs)
legend('original data','numerical difference','filtered difference',...
    'location','northwest')
ylim([1e-3 1e2])

%% analog differentiator (given by numerical simulation)
s = tf('s');
T1 = 5*Ts;
sys1 = tf([1 0],[T1 1]);
y21 = lsim(sys1,x,t);

T2 = 10*Ts;
sys2 = tf([1 0],[T1*T2, T1+T2, 1]);
y22 = lsim(sys2,x,t);


figure
plot(t,y21,'DisplayName','use one LPF')
hold on
grid on
plot(t,y22,'DisplayName','use two LPFs')
plot(t,y0,'DisplayName','real derivaticve')
legend
xlabel('Time (s)')
xlim([0 10])

%% tracking differentiator
h = 10*Ts;
r = (2*pi*10/1.44)^2;               % approximation: wc = 1.14*sqrt(r)
d = r*h^2;

K = length(x);
[x1,x2] = deal(0);
y3 = zeros(size(x));
for k = 1:K
    % fhan: p107, E.q.(2.7.24)
    a0 = h*x2;
    y = x1-x(k,:)+a0;
    a1 = sqrt(d.*(d+8*abs(y)));
    a2 = a0+sign(y).*(a1-d)/2;
    sy = (sign(y+d)-sign(y-d))/2;
    a = (a0+y-a2).*sy+a2;
    sa = (sign(a+d)-sign(a-d))/2;
    fhan = -r*(a/d-sign(a)).*sa-r*sign(a);
    
    x2 = x2+fhan*Ts;
    x1 = x1+x2*Ts;
    
    y3(k) = x2;
end

figure
plot(t,y3,'DisplayName','tracking differentiator')
hold on
grid on
plot(t,y0,'DisplayName','real derivaticve')
legend
xlabel('Time (s)')
xlim([0 10])

figure
iLPSD(x,fs)
hold on
iLPSD(y3,fs)
legend('original data','tracking differentiator',...
    'location','northwest')
ylim([1e-3 1e2])

%% results
figure
plot(t1,y1f,'DisplayName','filtered difference')
hold on
grid on
plot(t,y21,'DisplayName','use one LPF')
plot(t,y22,'DisplayName','use two LPFs')
plot(t,y3,'DisplayName','tracking differentiator')
plot(t,y0,'DisplayName','real derivaticve')
legend
xlabel('Time (s)')
xlim([0 10])

figure
iLPSD(y1f,fs)
hold on
iLPSD([y21 y22 y3],fs)
legend('filtered difference',...
    'use one LPF',...
    'use two LPFs',...
    'tracking differentiator')
ylim([1e-3 1e2])