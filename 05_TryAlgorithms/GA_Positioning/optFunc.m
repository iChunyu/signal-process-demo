% Least sqaure method: target function
%   pos --- postion: nx3 matrix
%  dist --- distance 1x4 vector
%     A --- anchor positon 4x3 matrix

% XiaoCY 2021-10-15

%%
function es = optFunc(pos,dist,A)
    es = zeros(size(pos,1),1);

    for k = 1:size(A,1)
        es = es + (vecnorm(pos-A(k,:),2,2)-dist(k)).^2;
    end
end