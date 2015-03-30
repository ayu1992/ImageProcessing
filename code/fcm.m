function [out, means] = fcm(K, img)
[M, N, d] = size(img);
EPS = 0.001;
%init
means = zeros(K, 3);
covars = {};
ass = zeros(M * N, K);
for i = 1 : M * N
    ass(i, mod(i, K) + 1) = 1;
end
rspimg = zeros(M * N, 3);
for i = 1 : M * N
    ii = mod(i, M) + 1;
    jj = ceil(i / M);
    for d = 1 : 3
        rspimg(i, d) = double(img(ii, jj, d));
    end
end

for rind = 1 : 10
    % calc means
    sums = zeros(K, 3);
    ws = zeros(K, 1);
    for i = 1 : M * N
        for k = 1 : K
            for d = 1 : 3
                sums(k, d) = sums(k, d) + ass(i, k) * rspimg(i, d);
                ws(k) = ws(k) + ass(i, k);
            end
        end
    end
    for k = 1 : K
        if ws(k) ~= 0
            means(k, :) = sums(k, :) / ws(k);
        end
    end
    % calc covar mat
    for k = 1 : K
        dm = rspimg - repmat(means(k, :), [M * N, 1]);
        covars{k} = (repmat(ass(:, k), [1 3]) .* dm)' * dm;
        covars{k} = covars{k} / ws(k) + diag([EPS EPS EPS]);
    end
    % reassign weight
    for i = 1 : M * N
        for k = 1 : K
            S = covars{k};
            mu = means(k, :);
            x = rspimg(i, :);
            ass(i, k) = (1 / sqrt(det(S))) * exp(-0.5 * (x - mu) * inv(S) * (x - mu)');
        end
    end
    
    ass = ass ./ repmat(sum(ass, 2), [1 K]);    
    disp(rind);
end
out = zeros(M, N);
for i = 1 : M * N
    ii = mod(i, M) + 1;
    jj = ceil(i / M);
    label = 1;
    best = ass(i, 1);
    for k = 2 : K
        if ass(i, k) > best
            best = ass(i, k);
            label = k;            
        end
    end
    out(ii, jj) = label;    
end

figure;
subplot(2, 1, 1); imshow(img);
subplot(2, 1, 2);
limg = zeros(M, N, 3);
for i = 1 : M
    for j = 1 : N
        for d = 1 : 3
            limg(i, j, d) = means(out(i, j), d);
        end
    end
end
imshow(uint8(limg));
            
end