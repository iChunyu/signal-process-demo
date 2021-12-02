% 计算并展示方波的傅立叶级数

% XiaoCY 2021-11-29

%%
clear;clc
close all

fs = 1e3;
t = (0:1/fs:2)';
sig = square(2*pi*t);
an = 0;
bn = @(n) 4./n/pi;

%%
calcOrder = 1:2:21;
showOrder = [1 7 14 21];


figure
plot(t,sig,'DisplayName','Square')
hold on
grid on
fsig = sig*0;
for k = calcOrder
    fsig = fsig + bn(k)*sin(2*pi*k*t);
    if any(k==showOrder)
        plot(t,fsig,'DisplayName',sprintf('Fourier (N=%d)',k))
    end
end
legend('Location','northoutside','Orientation','horizontal')
xlabel('Time (s)')
ylabel('Signal')

%%
calcOrder = 1:2:7;

figure
z = zeros(size(t));
plot3(t,z-1,sig);
hold on
grid on
fsig = z;
for k = calcOrder
    fsigk = bn(k)*sin(2*pi*k*t);
    fsig = fsig + fsigk;
    plot3(t,z+k,fsigk)
end
plot3(t,z+k+2,fsig)
view(65,32)

f = 0:calcOrder(end);
A = f*0;
A(2:2:end) = bn(calcOrder);
stem3(f*0,f,A,'filled','LineWidth',3)

xlabel('Time (s)')
ylabel('Frequency (Hz)')
zlabel('Signal')