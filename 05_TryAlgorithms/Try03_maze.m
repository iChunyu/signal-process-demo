% The maze problem:
% A maze is expressed by matrix 'A', where '1' represents wall
% Assume there is only one way out (from top left to bottom right, try to find it).

% Hint: always follow the right-side wall.

% XiaoCY 2022-08-05

%%
clear;clc

% define the maze here
A = [
    0 0 0 0 1 0
    1 0 1 0 1 0
    0 1 0 0 0 0
    0 0 0 0 1 0
    0 1 1 0 1 0
];

%%
% v: velocity, the next-step direction
%    1~4: right, up, left, down (note: applied to index)
%    the right-side is the previous direction `v(vi-1)`
% vi: direction index
v = [0 1; -1 0; 0 -1; 1 0];
vi = 1;                     

[M,N] = size(A);
path = nan(M*N,2);
path(1,:) = [1 1];
idx = 1;
m = 1;
n = 1;
while n~=N || m~=M
    % always try to turn right at first
    if vi == 1
        vi = 4;
    else
        vi = vi-1;
    end

    % try to go alone each direction
    for k = 1:4
        mk = m+v(vi,1);
        nk = n+v(vi,2);
        if mk>=1 && mk <=M && nk>=1 && nk<=N
            if A(mk,nk)==0
                % avaliable to walk to [mk,nk], go
                m = mk;
                n = nk;
                idx = idx+1;
                path(idx,:) = [m n];
                break
            else
                % meet wall, try next direction
                vi = mod(vi,4)+1;
            end
        else
            % meet boundary, try next direction
            vi = mod(vi,4)+1;
        end
    end
end

% clean path: remove the way back
path(isnan(path(:,1)),:) = [];
idx = size(path,1);
while idx > 1
    % `isequal(path(i,:),path(j,:))` means 'walk back',
    % path between these indexs should be removed
    for k = 1:idx-1
        if isequal(path(k,:),path(idx,:))
            path(k+1:idx,:) = [];
            idx = k;
            break
        end
    end
    idx = idx-1;
end

%%
% show result with `heatmap` (I'm lazy to optimize this)
Ts = 0.1;
figure('WindowStyle','normal')
heatmap(A,'CellLabelColor','none','ColorbarVisible','off')
pause(Ts)
for k = 1:size(path,1)
    B = A;
    B(path(k,1),path(k,2)) = 0.5;
    heatmap(B,'CellLabelColor','none','ColorbarVisible','off')
    pause(Ts)
end