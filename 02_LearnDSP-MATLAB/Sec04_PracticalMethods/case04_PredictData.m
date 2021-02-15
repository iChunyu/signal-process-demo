% Predict data Forward/backword
% Use AR model to do prediction
% Use extended data to cancel transient dynamic in filtering

% XiaoCY 2021-02-15

%%
clear;clc

fs = 500;
t = (0:1/fs:10)';
x0 = cos(2*pi*t)+0.2*sin(2*pi*10*t);    % origin signal

p = 21;                                 % prediction model order

N0 = length(x0);                        % true data
N = floor(N0*0.9);                      % given data
M = N0-N;                               % points to be estimated

%% forward prediction
x1 = x0(1:N);

% Two methods to calculate AR coefficients
a11 = lpc(x1,p);
a12 = arburg(x1,p);

y11 = ipredict(x1,a11,M,'forward');
y12 = ipredict(x1,a12,M,'forward');

figure('Name','forward')
subplot(2,1,1)
plot(t,y11,'DisplayName','lpc')
hold on
grid on
plot(t,y12,'DisplayName','arburg')
plot(t,x0,'--','DisplayName','real')
legend
xlabel('Time (s)')
ylabel('Signal')

subplot(2,1,2)
idx = N:N0;
plot(t(idx),y11(idx)-x0(idx),'DisplayName','lpc')
hold on
grid on
plot(t(idx),y12(idx)-x0(idx),'DisplayName','arburg')
legend
xlabel('Time (s)')
ylabel('Prediction error')

%% backward prediction
x2 = x0(end-N+1:end);

a21 = lpc(x2,p);
a22 = arburg(x2,p);

y21 = ipredict(x2,a21,M,'backward');
y22 = ipredict(x2,a22,M,'backward');

% prediction with reversed data
x2t = x2(end:-1:1);
y23 = ipredict(x2t,lpc(x2t,p),M,'forward');
y23 = y23(end:-1:1);

y24 = ipredict(x2t,arburg(x2t,p),M,'forward');
y24 = y24(end:-1:1);

figure('Name','forward')
subplot(2,1,1)
plot(t,y21,'DisplayName','lpc')
hold on
grid on
plot(t,y22,'DisplayName','arburg')
plot(t,y23,'DisplayName','reversed-lpc')
plot(t,y23,'DisplayName','reversed-arburg')
plot(t,x0,'--','DisplayName','real')
legend
xlabel('Time (s)')
ylabel('Signal')

subplot(2,1,2)
idx = 1:M;
plot(t(idx),y21(idx)-x0(idx),'DisplayName','lpc')
hold on
grid on
plot(t(idx),y22(idx)-x0(idx),'DisplayName','arburg')
plot(t(idx),y23(idx)-x0(idx),'--','DisplayName','reversed-lpc')
plot(t(idx),y24(idx)-x0(idx),'--','DisplayName','reversed-arburg')
legend
xlabel('Time (s)')
ylabel('Prediction error')

%% twosided prediction to cancel transient dynamic in filtering
[N,Wn] = ellipord(3/(fs/2),5/(fs/2),1,40);         % digital filter
[b,a] = ellip(N,1,40,Wn);

y1 = filtfilt(b,a,x0);

ar = arburg(x0,p);
xx = ipredict(x0,ar,M,'twosided');
y2 = filtfilt(b,a,xx);
y2 = y2(M+1:end-M);

figure('Name','filter')
plot(t,y1,'DisplayName','direct filter')
hold on
grid on
plot(t,y2,'DisplayName','extended filter')
legend
xlabel('Time (s)')
ylabel('Signal')

%% subfunction
function y = ipredict(x,ar,M,mode)
    N = length(x);
    p = length(ar)-1;
    
    if strcmp(mode,'forward')
        y = [x; zeros(M,1)];
        for m = 1:M
            for k = 1:p
                y(N+m) = y(N+m) - y(N+m-k)*ar(1+k);
            end
        end
    elseif strcmp(mode,'backward')
        y = [zeros(M,1);x];
        for m = 1:M
            for k = 1:p
                y(M+1-m) = y(M+1-m) - y(M+1-m+k)*ar(1+k);
            end
        end
    elseif strcmp(mode,'twosided')
        y = [zeros(M,1);x;zeros(M,1)];
        for m = 1:M
            for k = 1:p
                y(N+M+m) = y(N+M+m) - y(N+M+m-k)*ar(1+k);
                y(M+1-m) = y(M+1-m) - y(M+1-m+k)*ar(1+k);
            end
        end
    else
        error('mode = ''forward''|''backward''|''twosided''')
    end
end