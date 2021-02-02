% Plot frequency spectrum to analysis singal in frequency domain
% Key: align to frequency points

% XiaoCY 2021-02-02

%% time domain
clear;clc

fs = 1000;                      % sampling frequency
fsig = 100;                     % signal frequency
fext = 250;                     % extra frequency (noise)

t = (0:1/fs:100/fsig)';         % time series
N = length(t);                  % number of samples

x = cos(2*pi*fsig*t)+0.2*sin(2*pi*fext*t);

figure('Name','time')
plot(t,x)
grid on
xlabel('Time (s)')
ylabel('Signal')

%% frequency domain
X = fft(x);

Nf = floor(N/2);                % number of frequency points
f = (0:Nf)'*fs/N;

amp = abs(X(1:Nf+1))*2/N;
phase = angle(X(1:Nf+1));


figure('Name','FFT')            % show real part and imaginary part
subplot(2,1,1)
plot(f,real(X(1:Nf+1)))
grid on
xlabel('Frequency (Hz)')
ylabel('Re(X)')

subplot(2,1,2)
plot(f,imag(X(1:Nf+1)))
grid on
xlabel('Frequency (Hz)')
ylabel('Im(X)')


figure('Name','spectrum')       % show frequency spectrum
subplot(2,1,1)
plot(f,amp)
grid on
xlabel('Frequency (Hz)')
ylabel('Amplitude')

subplot(2,1,2)
plot(f,phase)
grid on
xlabel('Frequency (Hz)')
ylabel('Phase (rad)')