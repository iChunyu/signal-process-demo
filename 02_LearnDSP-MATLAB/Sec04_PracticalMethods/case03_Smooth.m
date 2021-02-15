% Smooth data

% XiaoCY 2021-02-15

%%
clear;clc

fs = 100;
t = (0:1/fs:20)';
x0 = cos(2*pi*t);
xn = randn(size(t))*0.2;
x = x0+xn;

%% five-spot triple smoothing method
m = 21;                         % smooth times

a = x;
y1 = x;
N = length(x);
for k = 1:m
    y1(1) = (69*a(1) + 4*(a(2)+a(4)) - 6*a(3) - a(5))/70;
    y1(2) = (2*(a(1)+a(5)) + 27*a(2) + 12*a(3) - 8*a(4))/35;
    for j = 3:N-2
        y1(j) = (-3*(a(j-2)+a(j+2)) + 12*(a(j-1)+a(j+1)) + 17*a(j))/35;
    end
    y1(N-1) = (2*(a(N-4)+a(N)) - 8*a(N-3) + 12*a(N-2) + 27*a(N-1))/35;
    y1(N) = (-a(N-4) + 4*(a(N-3)+a(N-1)) - 6*a(N-2) + 69*a(N))/70;
    a = y1;
end

%% built-in function
y21 = smooth(x,21,'moving');
y22 = smooth(x,21,'lowess');
y23 = smooth(x,21,'loess');
y24 = smooth(x,21,'sgolay');

y3 = sgolayfilt(x,5,21);

%%
figure
plot(t,x,'DisplayName','origin')
hold on
grid on
plot(t,y1,'DisplayName',sprintf('mean53(%d)',m))
plot(t,y21,'DisplayName','Smooth-moving')
plot(t,y22,'DisplayName','Smooth-lowess')
plot(t,y23,'DisplayName','Smooth-loess')
plot(t,y24,'DisplayName','Smooth-sgolay')
plot(t,y3,'DisplayName','Savitzky-Golay')
legend
xlabel('Time (s)')
ylabel('Signal')

figure
iLPSD([x,y1,y21,y22,y23,y24,y3],fs)
xlabel('Frequency (Hz)')
ylabel('PSD')
legend('origin',sprintf('mean53(%d)',m),'Smooth-moving',...
    'Smooth-lowess','Smooth-loess','Smooth-sgolay','Savitzky-Golay')