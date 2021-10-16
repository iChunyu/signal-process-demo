% split vector into indivitual integers
%     vec --- row vector (or matrix made up of row vectors)
%    nInt --- integer part
%   nFrac --- fraction part
% eg: splitNum(3.14159,1,2) = [3 1 4]
%     splitNum([3.14 2.71],1,2) = [3 1 4 2 7 1];
    
% XiaoCY 2021-10-15

%%
function y = splitVec(vec,nInt,nFrac)
    [nRow, nCol] = size(vec);
    nDec = nInt+nFrac;
    y = nan(nRow,nDec*nCol);
    
    x = round(vec*10^nFrac);
    for xCol = 1:nCol
        for k = 1:nDec
            yCol = (xCol-1)*nDec+k;
            y(:,yCol) = floor(x(:,xCol)./10^(nDec-k));
            x(:,xCol) = mod(x(:,xCol),10^(nDec-k));
        end
    end
end