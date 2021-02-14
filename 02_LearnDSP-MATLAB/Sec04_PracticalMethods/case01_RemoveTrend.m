% Remove polynomial trend in signal
% Polynominal curve fitting and cancelling

% XiaoCY 2021-02-14

%%
clear;clc

fs = 100;
fsig = 1;
p0 = [-0.05, 1, -0.3];
t = (0:1/fs:10)';
trend = polyval(p0,t);
x0 = sin(2*pi*fsig*t)+trend;

%%
p = polyfit(t,x0,2);
trendfit = polyval(p,t);
x1 = x0-trendfit;
x2 = detrend(x0,2);

figure
plot(t,x0,'DisplayName','origin')
hold on
plot(t,x1,'DisplayName','polydetrend')
plot(t,x2,'--','DisplayName','detrend')
plot(t,trendfit,'DisplayName','trendfit')
plot(t,trend,'--','DisplayName','trend')
grid on
legend
xlabel('Time (s)')
ylabel('Signal')
