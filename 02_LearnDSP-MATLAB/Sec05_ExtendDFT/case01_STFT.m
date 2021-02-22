% Short Time Fourier Transform (STFT)

% XiaoCY 2021-02-22

%%
clear;clc

fs = 1000;
t = (0:1/fs:100)';
x = chirp(t,0,t(end),300,'quadratic');

%%
nfft = 512;
win = hanning(nfft);
noverlap = floor(nfft*0.6);

% Onesided
[s1,f1,t1] = spectrogram(x,win,noverlap,nfft,fs);

% Twosided
[s2,f2,t2] = stft(x,fs,'Window',win,'OverlapLength',noverlap,'FFTLength',nfft);
idx = f2<0;
f2(idx) = [];
s2(idx,:)=[];

% s1 == s2
if find(s1~=s2)
    wanning('Not equal')
end

%%
figure('Name','time')
plot(t,x)
grid on
xlabel('Time (s)')
ylabel('Chirp')
xlim([0 15])


% normalize
S = abs(s1)*2/sum(win);         

figure('Name','mesh')
mesh(t1,f1,S)
view(0,90)
colorbar
xlabel('Time (s)')
ylabel('Frequency (Hz)')
zlabel('STFT')

figure('Name','surf')
surf(t1,f1,S)
view(0,90)
colorbar
xlabel('Time (s)')
ylabel('Frequency (Hz)')
zlabel('STFT')

figure('Name','imagesc')
imagesc(t1,f1,S)
axis xy
view(0,90)
colorbar
xlabel('Time (s)')
ylabel('Frequency (Hz)')
zlabel('STFT')