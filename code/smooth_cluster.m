function [newlabels, newmeans] = smooth_cluster( labels, img )
R = 2;
K = max(max(labels));
[M, N] = size(labels);
newlabels = zeros(M, N);
for i = 1 : M
    for j = 1 : N
        newlabels(i, j) = find_neighbor_mode(labels, K, R, i, j);
    end
end
sums = zeros(K, 3);
cnts = zeros(K, 3);
for i = 1 : M
    for j = 1 : N
        k = newlabels(i, j);
        for d = 1 : 3
            sums(k, d) = sums(k, d) + double(img(i, j, d));
            cnts(k, d) = cnts(k, d) + 1;        
        end

    end
end
newmeans = sums ./ cnts;
end

function out = find_neighbor_mode(labels, K, R, x, y)
cnts = zeros(K, 1);
[M, N] = size(labels);
for i = max(1, x - R) : min(M, x + R)
    for j = max(1, y - R) : min(N, y + R)
        cnts(labels(i, j)) = cnts(labels(i, j)) + 1;
    end
end
out = 1;

cnt = sum(cnts == 1);
for i = 2 : K
    ncnt = sum(cnts == i);
    if ncnt > cnt
        out = i;
        cnt = ncnt;
    end
end
end


