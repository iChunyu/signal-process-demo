% Try K-means algorithm to cluster data

% XiaoCY 2021-09-01

%%
clear;clc
close all

% algorithm options
showProcess = true;
maxIteration = 100;

% define color to show results
colorVec = [
    0.1765  0.5216  0.9412
    0.9569  0.2627  0.2353
    0.0392  0.6588  0.3451 ];

% generate random data
X = [1.8*randn(200,1)+1  1.8*randn(200,1)+7
    1.8*randn(200,1)+4   1.7*randn(200,1)+2
    1.6*randn(200,1)+9   1.8*randn(200,1)+6];

nData = size(X,1);                      % data length
p = randperm(nData)';
X = X(p,:);                             % disarrange data

%%
K = 3;                                  % number of clusters
cIndex = zeros(nData,1);                % index of clusters
xc = X(randi(nData,K,1),:);             % initialize center of clusters (random pick)

for nIter = 1:maxIteration
    
    for n = 1:nData
        d = X(n,:) - xc;
        dnorm = vecnorm(d,2,2);
        [~,idx] = min(dnorm);
        cIndex(n) = idx;
    end
    
    xx = xc;
    for k = 1:K
        kIndex = cIndex == k;
        xc(k,:) = mean(X(kIndex,:));
        
        if showProcess
            try
                s(k).delete
                sc(k).delete
            catch
                % pass
            end
            
            s(k) = scatter(X(kIndex,1),X(kIndex,2),'filled','markerfacecolor',colorVec(k,:));
            hold on
            sc(k) = scatter(xc(k,1),xc(k,2),700,'filled',...
                'markerfacecolor',colorVec(k,:),'marker','h');
        end
    end
    
    if showProcess
        axis off
        grid off
        title(sprintf('Iteration = %d',nIter))
        pause(0.5)
    end
    
    % write gif file
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if nIter == 1
        imwrite(imind,cm,'kmeans-demo.gif','gif', 'Loopcount',inf,'DelayTime',0.5);
    else
        imwrite(imind,cm,'kmeans-demo.gif','gif','WriteMode','append','DelayTime',0.5);
    end
    
    if xc == xx
        break
    end
end