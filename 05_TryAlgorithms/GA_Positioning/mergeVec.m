% merge ingeters into vectors
    % y --- vectors to be split
    % nInt --- bits of integer
    % nFrac --- bits of fraction
% eg: mergeVec([3 1 4 2 7 1],1,2) = [3.14 2.71]

% XiaoCY 2021-10-15

%%
function vec = mergeVec(y,nInt,nFrac)
    [nRow,nCol] = size(y);
    nDec = nInt+nFrac;
    if mod(nCol,nDec)~=0
        error('Dimension error')
    end
    
    nDim = nCol/nDec;
    vec = zeros(nRow,nDim);
    
    for xCol = 1:nDim
        for k = 1:nDec
            yCol = (xCol-1)*nDec+k;
            vec(:,xCol) = vec(:,xCol)+y(:,yCol)*10^(nInt-k);
        end
    end
end