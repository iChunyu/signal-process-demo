% Fast Fourier Transformation (FFT)
% Radix-2 Decimation in Time

% XiaoCY 2021-02-01

%%
clear;clc

% X(k) = X1(k) + WN^k X2(k)
% WN(k) = exp(-1i*2*pi*k/N)

%% data
M = 10;
N = 2^M;
x = randn(N,1);                                 % origin data

%% FFT
tic

idx = 0:N-1;                                    % zero-based normal index
iidx = bin2dec(fliplr(dec2bin(idx,M)));         % zero-based inversed index

X = x(iidx+1);                                  % inversed data sequence

for m = 1:M
    Nm = 2^m;
    Nr = Nm/2;
    Wm = exp(-1i*2*pi/Nm);
    Wmk = 1;
    for n = 1:Nr
        for k = n:Nm:N
            kp = k + Nr;
            WX = X(kp)*Wmk;
            X(kp) = X(k)-WX;
            X(k) = X(k)+WX;
        end
        Wmk = Wmk*Wm;
    end
end

toc

%%
Y = fft(x);

ReX = real(X);
ImX = imag(X);
ReY = real(Y);
ImY = imag(Y);

figure
subplot(2,2,1)
plot(idx,ReX)
hold on
plot(idx,ReY,'--')
grid on
xlabel('Index')
ylabel('Real part')

subplot(2,2,2)
plot(idx,ImX)
hold on
plot(idx,ImY,'--')
grid on
xlabel('Index')
ylabel('Imaginary part')

subplot(2,2,3)
plot(idx,ReY-ReX)
grid on
xlabel('Index')
ylabel('Real error')

subplot(2,2,4)
plot(idx,ImY-ImX)
grid on
xlabel('Index')
ylabel('Imaginary error')