% Try genetic algorithm to find the maximun of a given function

% XiaoCY 2021-09-06

%%
clear;clc
close all

% find xf s.t. max(f(x)) = f(xm) for all x in [0,10]
f = @(x) sin(x*0.3*pi).^2 + exp(-(x-5).^2);

% algorithm options
nChromosome = 50;               % number of chromosome
nCross = 10;                    % half number of chromosome for crossover
nMutation = 10;                 % number of chromosome for mutation
nGeneration = 30;               % generations for iteration

showProcess = true;


% precision
nInt = 1;
nFrac = 6;
gCross = 3;                     % crossover gene
gMutation = 3;                  % mutation gene

%%
% initialize
x = rand(nChromosome,1);
[~,idx] = max(f(x));
xf = x(idx);
if showProcess
    x0 = linspace(0,10,1e3);
    plot(x0,f(x0))
    hold on
    Chrom(1) = scatter(x,f(x),50,'filled',...
        'markerfacecolor',[0.0392  0.6588  0.3451],'marker','o');
    Chrom(2) = scatter(xf,f(xf),150,'filled',...
        'markerfacecolor',[0.9843  0.4471  0.6000],'marker','v');
    title('Initial Condition')
    
    % write gif file
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,'genetic-demo.gif','gif', 'Loopcount',inf,'DelayTime',1);
end

for k = 1:nGeneration
    % get gene series
    xGene = splitNum(x,nInt,nFrac);
    
    % corssover
    x1 = xGene(randperm(nChromosome,nCross),:);
    x2 = xGene(randperm(nChromosome,nCross),:);
    gidx = randperm(nInt+nFrac,gCross);
    xt = x1;
    x1(:,gidx) = x2(:,gidx);
    x2(:,gidx) = xt(:,gidx);
    xc = mergeNum([x1;x2],nInt);
    
    % mutation
    x3 = xGene(randperm(nChromosome,nMutation),:);
    for m = 1:nMutation
        gidx = randperm(nInt+nFrac,gMutation);
        x3(m,gidx) = randperm(9,gMutation);
    end
    xm = mergeNum(x3,nInt);
    
    xk = [x;xc;xm];
    fk = f(xk);
    [~,idx] = sort(fk,'descend');
    x = xk(idx(1:nChromosome));
    xf0 = xf;
    xf = xk(idx(1));
    
    if showProcess
        Chrom.delete;
        
        Chrom(1) = scatter(x,f(x),50,'filled',...
            'markerfacecolor',[0.0392  0.6588  0.3451],'marker','o');
        Chrom(2) = scatter(xf,f(xf),150,'filled',...
            'markerfacecolor',[0.9843  0.4471  0.6000],'marker','v');
        title(sprintf('Iteration = %d',k))
        
        % write gif file
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if k <= 10
            imwrite(imind,cm,'genetic-demo.gif','gif','WriteMode','append','DelayTime',0.5);
        else
            imwrite(imind,cm,'genetic-demo.gif','gif','WriteMode','append','DelayTime',0.2);
        end
    end
end

fprintf('Max f(x) appears in x=%f and fmax = %f\n',xf,f(xf))

%% subfunctions
function y = splitNum(x,nInt,nFrac)
    % split float numbers into indivitual integers
    % x --- number to be split
    % nInt --- integer
    % eg: splitNum(3.14159,1,2) = [3 1 4]
    %     splitNum(3.14159,1,5) = [3 1 4 1 5 9];
    
    nbit = nInt+nFrac;
    y = nan(length(x),nbit);
    xt = round(mod(x,10^nInt)*10^nFrac);
    for k = 1:nbit
        y(:,k) = floor(xt/10^(nbit-k));
        xt = mod(xt,10^(nbit-k));
    end
end

function x = mergeNum(y,nInt)
    % merge ingeters into float numbers
    % x --- number to be split
    % nInt --- bits of integer
    % nFrac --- bits of fraction
    % eg: mergeNum([3 1 4],1) = 3.14
    
    [N,nbit] = size(y);
    x = zeros(N,1);
    for k = 1:nbit
        x = x+y(:,k)*10^(nInt-k);
    end
end