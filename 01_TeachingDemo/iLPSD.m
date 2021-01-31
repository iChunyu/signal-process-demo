% Use LPSD mothod to plot power spectral density
% [Pxx,f] = iLPSD(Data,fs,Jdes)
%    Data --- Input data, processed by column
%    fs   --- Sample frequency, unit: Hz
%    Jdes --- Desired frequency points, default: 1000
%    Pxx  --- One-sided PSD, unit: *^2/Hz
%    f    --- Frequency points related to PSD points, unit: Hz
%    Default window function is hanning window.
% Demo:
%    iLPSD(data,fs)
%       Plot PSD using default settings.
%    h = iLPSD(data,fs,Jdes)
%       Plot PSD with desired points of 1000
%    [Pxx,f] = iLPSD(data,fs)
%       Return PSD points, not plot any figure

% Ref: Improved spectrum estimation from digitized time series on a logarithmic frequency axis
%      Article DOI: 10.1016/j.measurement.2005.10.010

% XiaoCY 2020-04-21

%% Main
function varargout = iLPSD(varargin)
    
    nargoutchk(0,2);
    narginchk(2,3);
    
    data = varargin{1};
    fs = varargin{2};
    if nargin == 3
        Jdes = varargin{3};
    else
        Jdes = 1000;
    end
    
    Kdes = 100;
    ksai = 0.5;
    
    [N,nCol] = size(data);
    if N==1 && nCol~=1
       data = data';
       N = nCol;
       nCol = 1;
    end
    
    [f,L,m] = getFreqs(N,fs,Jdes,Kdes,ksai);
    
    J = length(f);
    P = zeros(J,nCol);
    for j = 1:J
        Dj = floor((1-ksai)*L(j));
        Kj = floor((N-L(j))/Dj+1);
        w = hann(L(j));
        C_PSD = 2/fs/sum(w.^2);
        l = (0:L(j)-1)';
        W1 = cos(-2*pi*m(j)/L(j).*l);
        W2 = sin(-2*pi*m(j)/L(j).*l);
        A = zeros(1,nCol);
        for k = 0:Kj-1
            G = data(k*Dj+1:k*Dj+L(j),:);
            G = G-mean(G);        % G = detrend(G);   
            G = G.*w;
            A = A + sum(G.*W1).^2+sum(G.*W2).^2;
        end
        P(j,:) = A/Kj*C_PSD;
    end
    
    switch nargout
        case 0
            PlotPSD(P,f)
        case 1
            varargout{1} = PlotPSD(P,f);
        case 2
            varargout{1} = P;
            varargout{2} = f;
        otherwise
            % Do Nothing
    end
end

%% Subfunctions
% get logarithmic frequency points
function [f,L,m] = getFreqs(N,fs,Jdes,Kdes,ksai)
    fmin = fs/N;
    fmax = fs/2;
    r_avg = fs/N*(1+(1-ksai)*(Kdes-1));
    
    g = (N/2)^(1/(Jdes-1))-1;
    
    f = zeros(Jdes,1)-1;
    L = f;
    m = f;
    j = 1;
    fj = fmin;
    while fj < fmax
        rj = fj*g;
        if rj < r_avg
            rj = sqrt(rj*r_avg);
        end
        if rj < fmin
            rj = fmin;
        end
        
        Lj = floor(fs/rj);
        rj = fs/Lj;
        mj = fj/rj;
        
        f(j) = fj;
        L(j) = Lj;
        m(j) = mj;
        
        fj = fj+rj;
        j = j+1;
    end
    f(f<0) = [];
    L(L<0) = [];
    m(m<0) = [];
end

% plot PSD
function varargout = PlotPSD(P,f)
    hLine = loglog(f,sqrt(P));
    grid on
    xlabel('Frequency (Hz)')
    ylabel('PSD ([Unit]/Hz^{1/2})')
    
    if nargout == 1
        varargout{1} = hLine;
    end
end