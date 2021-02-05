% Design filter using built-in functions
% Show frequency response
% Low-pass analog filter for example

% XiaoCY 2021-02-05

%%
clear;clc

Wp = 1;                     % passband corner frequency (rad/s)
Ws = 3;                     % stopband corner frequency (rad/s)
Rp = 1;                     % passband ripple (dB)
Rs = 40;                    % stopband attenuation (dB)
w = linspace(0,5,500);

%% Butterworth
[n,Wn] = buttord(Wp,Ws,Rp,Rs,'s');
[b,a] = butter(n,Wn,'s');
h = freqs(b,a,w);

figure
plot(w,mag2db(abs(h)),'DisplayName',sprintf('Butterworth (N=%d)',n))
hold on
grid on

%% Chebyshev Type I
[n,Wn] = cheb1ord(Wp,Ws,Rp,Rs,'s');
[b,a] = cheby1(n,Rp,Wn,'s');

h = freqs(b,a,w);
plot(w,mag2db(abs(h)),'DisplayName',sprintf('Chebyshev1 (N=%d)',n))

%% Chebyshev Type II
[n,Wn] = cheb2ord(Wp,Ws,Rp,Rs,'s');
[b,a] = cheby2(n,Rs,Wn,'s');

h = freqs(b,a,w);
plot(w,mag2db(abs(h)),'DisplayName',sprintf('Chebyshev2 (N=%d)',n))

%% Elliptic
[n,Wn] = ellipord(Wp,Ws,Rp,Rs,'s');
[b,a] = ellip(n,Rp,Rs,Wn,'s');

h = freqs(b,a,w);
plot(w,mag2db(abs(h)),'DisplayName',sprintf('Elliptic (N=%d)',n))
legend
xlabel('Frequency (rad/s)')
ylabel('Gain (dB)')