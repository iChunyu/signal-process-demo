% 使用遗传算法求解 TOA 定位中的最小二乘问题
% 输入：
%       dist --- 测点到锚点的距离
%          A --- 锚点的位置，每个锚点位置坐标占一行
%     nChrom --- 种群数量，默认 5000
%     nCross --- 交叉数量，默认 1500 （交叉后生成双倍新个体）
%     nMutat --- 变异数量，默认 2000
%      nIter --- 最大迭代次数，默认 500
%     nCheck --- 提前终止的检验次数，默认 50
%       nInt --- 位置的整数位，默认为 4
%      nFrac --- 位置的小数位，默认为 2
%                默认情况下 nInt 和 nFrac 决定的基因总数为 18 = (4+2)*3
%     gCross --- 交叉的基因数量，默认为 9
%     gMutat --- 变异的基因数量， 默认为 9

% XiaoCY 2021-10-15

%%
function varargout = getPosition(varargin)

    p = inputParser;
    addRequired(p,'dist')
    addRequired(p,'A')
    addParameter(p,'nChrom',5000)
    addParameter(p,'nCross',1500)
    addParameter(p,'nMutat',2000)
    addParameter(p,'nIter',500)
    addParameter(p,'nCheck',50)
    addParameter(p,'nInt',4)
    addParameter(p,'nFrac',2)
    addParameter(p,'gCross',9)
    addParameter(p,'gMutat',9)
    addParameter(p,'showProcess',false)
    parse(p,varargin{:})

    dist = p.Results.dist;
    A = p.Results.A;
    nChrom = p.Results.nChrom;
    nCross = p.Results.nCross;
    nMutat = p.Results.nMutat;
    nIter = p.Results.nIter;
    nCheck = p.Results.nCheck;
    nInt = p.Results.nInt;
    nFrac = p.Results.nFrac;
    gCross = p.Results.gCross;
    gMutat = p.Results.gMutat;
    showProcess = p.Results.showProcess;
    nDec = (nInt+nFrac)*size(A,2);

    pos = [rand(nChrom,2)*5000 rand(nChrom,1)*3000];
    es = optFunc(pos,dist,A);
    [~,idx] = min(es);
    tag = pos(idx,:);
    chk = 0;

    if showProcess
        figure
        Chrom(1) = scatter3(pos(:,1),pos(:,2),pos(:,3),'filled',...
            'markerfacecolor',[0.0392  0.6588  0.3451],'marker','o');
        hold on
        Chrom(2) = scatter3(tag(1),tag(2),tag(3),'filled',...
            'markerfacecolor',[0.9843  0.4471  0.6000],'marker','p');
        title('Initial Condition')
    end


    for k = 1:nIter
        % get gene series
        pGene = splitVec(pos,nInt,nFrac);

        % corssover
        p1 = pGene(randperm(nChrom,nCross),:);
        p2 = pGene(randperm(nChrom,nCross),:);
        gidx = randperm(nDec,gCross);
        pt = p1;
        p1(:,gidx) = p2(:,gidx);
        p2(:,gidx) = pt(:,gidx);
        pc = mergeVec([p1;p2],nInt,nFrac);

        % mutation
        p3 = pGene(randperm(nChrom,nMutat),:);
        for m = 1:nMutat
            gidx = randperm(nDec,gMutat);
            p3(m,gidx) = randi(10,1,gMutat)-1;
        end
        pm = mergeVec(p3,nInt,nFrac);


        posNew = [pos;pc;pm];
        es = optFunc(posNew,dist,A);
        [~,idx] = sort(es,'ascend');
        pos = posNew(idx(1:nChrom),:);
        tagEs = es(idx(1));
        if tag == posNew(idx(1),:)
            chk = chk+1;
        else
            chk = 0;
            tag = posNew(idx(1),:);
        end

        if showProcess
            Chrom.delete;
            Chrom(1) = scatter3(pos(:,1),pos(:,2),pos(:,3),'filled',...
                'markerfacecolor',[0.0392  0.6588  0.3451],'marker','o');
            hold on
            Chrom(2) = scatter3(tag(1),tag(2),tag(3),'filled',...
                'markerfacecolor',[0.9843  0.4471  0.6000],'marker','p');
            title(sprintf('Iteration = %d',k))
            pause(0.1)
        end

        if chk == nCheck
            break
        end
    end

    fprintf('Iteration: %d\n',k)
    fprintf('Tag Postion (mm): %4.2f  %4.2f  %4.2f\n',tag)
    fprintf('Measured Distance (mm): %4.2f  %4.2f  %4.2f  %4.2f\n',dist)
    fprintf('Checked Distance (mm):  %4.2f  %4.2f  %4.2f  %4.2f\n',vecnorm(A-tag,2,2))

    switch nargout
        case 1
            varargout{1} = pos;
        case 2
            varargout{1} = pos;
            varargout{2} = tagEs;
    end
end