% Add zeros to the end of the data serie
% Compare the difference of the frequency spectrum with the origin
% Pay attention to the factor to normalize the spectrum

% XiaoCY 2021-02-03

%%
clear;clc

fs = 1000;                      % sampling frequency
fsig = 100;                     % signal frequency

t = (0:1/fs:100/fsig)';         % time series
N = length(t);                  % number of samples
L = 2^nextpow2(N)*8;            % number of extended samples

x = cos(2*pi*fsig*t);           % origin data
xe = [x;zeros(L-N,1)];          % extended data

%%
X = fft(x);
Nf = floor(N/2);
f = (0:Nf)'*fs/N;
amp = abs(X(1:Nf+1))*2/N;

figure
plot(f,amp,'DisplayName','origin')
hold on
grid on

%%
Xe = fft(xe);
Nfe = floor(L/2);
fe = (0:Nfe)'*fs/L;
ampe = abs(Xe(1:Nfe+1))*2/N;

plot(fe,ampe,'DisplayName','extended')
legend
xlabel('Frequency (Hz)')
ylabel('Amplitude')
xlim([90 110])