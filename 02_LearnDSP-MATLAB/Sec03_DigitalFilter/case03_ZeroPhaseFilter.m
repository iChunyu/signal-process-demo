% Compare normal IIR filtering with zero-phase filtering
% Use digital filter

% XiaoCY 2021-02-08

%%
clear;clc

fs = 100;                               % sampling frequency (Hz)
fsig = 1;                               % signal frequency (Hz)

Wp = 3*fsig/(fs/2);                     % passband corner frequency (digital)
Ws = 5*fsig/(fs/2);                     % stopband corner frequency (digital)
Rp = 1;                                 % passband ripple (dB)
Rs = 40;                                % stopband attenuation (dB)

t = (0:1/fs:5)';
x0 = sin(2*pi*fsig*t);
xn = randn(size(x0))*0.3;
x = x0+xn;

%%
[N,Wn] = ellipord(Wp,Ws,Rp,Rs);         % digital filter
[b,a] = ellip(N,Rp,Rs,Wn);

x1 = filter(b,a,x);                     % normal filtering
x2 = filtfilt(b,a,x);                   % zero-phase filtering

% manual zero-phase filtering
x3 = filter(b,a,x);                     % step 1: normal filtering
x3 = x3(end:-1:1);                      % step 2: flip
x3 = filter(b,a,x3);                    % step 3: normal filtering
x3 = x3(end:-1:1);                      % step 4: flip

%%
figure
plot(t,x,'DisplayName','origin')
hold on
grid on
plot(t,x0,'--','DisplayName','real')
plot(t,x1,'DisplayName','filter')
plot(t,x2,'DisplayName','filtfilt')
plot(t,x3,'-.','DisplayName','manual')
legend
xlabel('Time (s)')
ylabel('Signal')