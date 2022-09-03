% Numbers in MATLAB are defaut to `double`
% double: 1 (sign) + 11 (Exponent, E0 = 1023) + 52 (Fraction)

% Note: https://ichunyu.github.io/typeconvert/
% XiaoCY 2022-09-03

%%
clear;clc
close all

E0 = 1023;
M0 = 2^52;
k = 0.0450;
R = int64((-E0 + k)*M0);

%% Show log2 approximation in [0,1]
t = linspace(0,1,500);
figure
plot(t,log2(1+t),'DisplayName','$y=\log_2(1+t)$')
hold on
grid on
plot(t,t+k,'DisplayName','$y=t+k$')
legend('Location','northwest')
xlabel('$t$')
ylabel('$y$')

%% Compare log2 v.s data-conversion approximation
x = logspace(-10,10,5e3);
xi = typecast(x,'int64');
y = log2(x);
yhat = double(xi+R)/M0;

figure
subplot(211)
semilogx(x,y,'DisplayName','$y=\log_2 x$')
hold on
grid on
semilogx(x,yhat,'LineStyle','--',...
    'DisplayName','$\hat{y}=M_0^{-1}\bigl(f_{\mathrm{int}}(x)+R\bigr)$')
legend('Location','southeast')
xlabel('$x$')
ylabel('$y$')

subplot(212)
semilogx(x,y-yhat,'DisplayName','$\tilde{y}=y-\hat{y}$')
grid on
legend('Location','northeast')
ylabel('$\tilde{y}$')
xlabel('$x$')

%% Fast reciprocal square root
x = 0.01:0.01:10;
y = 1./sqrt(x);

R2 = int64(1.5*(E0 - k)*M0);
Y0 = R2-typecast(x,'int64')/2;
y0 = typecast(Y0,'double');
y1 = y0.*(1.5 - x./2.*y0.^2);
y2 = y1.*(1.5 - x./2.*y1.^2);

figure
subplot(211)
plot(x,y,'DisplayName','$y$')
grid on
hold on
plot(x,y0,'DisplayName','$\hat{y}_0$')
plot(x,y1,'DisplayName','$\hat{y}_1$')
plot(x,y2,'DisplayName','$\hat{y}_2$')
legend('Location','northeast')
xlabel('$x$')
ylabel('$y$')

subplot(212)
semilogy(x,abs(y-y0),'DisplayName','$|y-\hat{y}_0|$')
hold on
grid on
semilogy(x,abs(y-y1),'DisplayName','$|y-\hat{y}_1|$')
semilogy(x,abs(y-y2),'DisplayName','$|y-\hat{y}_2|$')
legend('Location','northeast')
xlabel('$x$')
ylabel('$\tilde{y}$')