% Interpolate DFT to correct frequency/amplitude/phase
% Take a cosine wave for example

% XiaoCY 2021-02-23

%%
clear;clc

fs = 1e3;
N = 2e3;

t = (0:N-1)'/fs;
ax = 3.0;
fx = 12.3;
px = 0.5;
x = ax*cos(2*pi*fx*t+px);

%% uncorrect
X = fft(x);
Nf = round(N/2+0.5);
f = (0:Nf-1)*fs/N;
A = abs(X(1:Nf))*2/N;

[a1,k] = max(A);
f1 = f(k);
p1 = angle(X(k));

%% ratio method: rectangular window
if A(k-1) > A(k+1)
    dk = -A(k-1)/(A(k-1)+A(k));  
else
    dk = A(k+1)/(A(k+1)+A(k));
end
f2 = (k+dk-1)*fs/N;                 % Note: DFT index k starts from 0 in theory
a2 = a1/sinc(dk);
p2 = p1-dk*pi;

%% ratio method: hanning window
win = hanning(N);
X3 = fft(x.*win);
A3 = abs(X3(1:Nf))*2/sum(win);

[a3,k3] = max(A3);
p3 = angle(X3(k3));

if A3(k3-1) > A3(k3+1)
    dk = (A3(k3)-2*A3(k3-1))/(A3(k3-1)+A3(k3));  
else
    dk = (2*A3(k3+1)-A3(k3))/(A3(k3+1)+A3(k3));
end
f3 = (k3+dk-1)*fs/N;                 % Note: DFT index k starts from 0 in theory
a3 = a3*(1-dk^2)/sinc(dk);
p3 = p3-dk*pi;

%% results
fprintf('%18s%12s%12s%12s%12s\n','','Uncorrected','Rectwin','Hanning','True Value')
fprintf('%18s%12f%12f%12f%12f\n','Frequency (Hz)',f1,f2,f3,fx)
fprintf('%18s%12f%12f%12f%12f\n','Amplitude',a1,a2,a3,ax)
fprintf('%18s%12f%12f%12f%12f\n','Phase (rad)',p1,p2,p3,px)

xe1 = a1*cos(2*pi*f1*t+p1) - x;
xe2 = a2*cos(2*pi*f2*t+p2) - x;
xe3 = a3*cos(2*pi*f3*t+p3) - x;
figure
plot(t,[xe1 xe2 xe3])
grid on
legend('FFT','rect-correct','hann-corrcet')
xlabel('Time (s)')
ylabel('Error')