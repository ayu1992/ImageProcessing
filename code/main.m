function out = main(img, map)
Ks = 5;
Km = 5;
[slabels, smeans] = fcm(Ks, img);
[mlabels, mmeans] = fcm(Km, map);

% [nslabels, nsmeans] = smooth_cluster(slabels, img);
% %show_labels(img, nslabels, nsmeans);
% figure;subplot(2,1,1);imshow(uint8(img));
% subplot(2,1,2);imshow(uint8(255 * (nslabels - 1)));
% 
% [nmlabels, nmmeans] = smooth_cluster(mlabels, map);
% figure;subplot(2,1,1);imshow(uint8(map));
% subplot(2,1,2);imshow(uint8(255 * (nmlabels - 1)));

%show_labels(map, nmlabels, nmmeans);

out = img;
figure;
for k = 1 : Ks
    ind = closest_ind(smeans(k, :), mmeans);
    sfilter = (slabels == k);
    mfilter = (mlabels == ind);
    out = hisEqIter(out, map, 0, 0, 0, sfilter, mfilter);
    for i = 1 : 5
        t1 = rand() * pi / 2; 
        t2 = rand() * pi / 2; 
        t3 = rand() * pi / 2;
        out = hisEqIter(out, map, t1, t2, t3, sfilter, mfilter);
        out = hisEqIter(out, map, t2, t3, t1, sfilter, mfilter);
        out = hisEqIter(out, map, t3, t1, t2, sfilter, mfilter);
        out = hisEqIter(out, map, t1, t3, t2, sfilter, mfilter);
        out = hisEqIter(out, map, t3, t2, t1, sfilter, mfilter);
        out = hisEqIter(out, map, t2, t1, t3, sfilter, mfilter);
        disp(i);
    end
    
subplot(3, Ks, k); imshow(uint8(out));
subplot(3, Ks, Ks + k); imshow(uint8(sfilter * 255));
subplot(3, Ks, 2 * Ks + k); imshow(uint8(mfilter * 255));
end

end

function ind = closest_ind(src, targets)
ind = 1;
mdist = norm(src - targets(1, :));
for i = 2 : size(targets, 1)
    dist = norm(src - targets(i, :));
    if dist < mdist
        mdist = dist;
        ind = i;
    end
end
end

function out = show_labels(img, labels, means)
out = 0;
[M, N, d] = size(img);
figure;
subplot(2, 1, 1); imshow(img);
subplot(2, 1, 2);
limg = zeros(M, N, 3);
for i = 1 : M
    for j = 1 : N
        for d = 1 : 3
            limg(i, j, d) = means(labels(i, j), d);
        end
    end
end
imshow(uint8(limg));
end
