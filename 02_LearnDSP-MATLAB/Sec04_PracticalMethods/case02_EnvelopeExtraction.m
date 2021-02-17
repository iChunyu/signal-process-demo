% Extract envelope curve of a modulated signal
% Use Hilbert transform

% XiaoCY 2021-02-14

%%
clear;clc

fs = 100;
fsig = 1;

mu = 4;
b = mu/3;
t = 0:1/fs:2*mu;
evlp = exp(-(t-mu).^2/(2*b^2));
x = sin(2*pi*fsig*t).*evlp;

%% Hilbert transform
y = hilbert(x);

figure
plot(t,x,'DisplayName','signal')
hold on
grid on
plot3(t,real(y),imag(y),'DisplayName','Hilbert')
legend
xlabel('Time (s)')
ylabel('Re(H)')
zlabel('Im(H)')
view(10,45)

figure
plot(t,x,'DisplayName','signal')
hold on
grid on
legend
plot(t,abs(y),'DisplayName','Hilbert')
plot(t,evlp,'--','DisplayName','envelope')
xlabel('Time (s)')
ylabel('Signal')

%% Transform with bias
bias = 1;
x1 = x+bias;
evlp1 = evlp+bias;

y1 = hilbert(x1);
xm = mean(x1);
y2 = hilbert(x1-xm);

figure
plot(t,x1,'DisplayName','signal')
hold on
grid on
legend
plot(t,abs(y1),'DisplayName','direct Hilbert')
plot(t,abs(y2)+xm,'DisplayName','bias-cancelled Hilbert')
plot(t,evlp1,'--','DisplayName','envelope')
xlabel('Time (s)')
ylabel('Signal')