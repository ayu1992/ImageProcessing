function out = hisEqIter(src, map, tx, ty, tz, sfilter, mfilter)
rotMat = getRotMat(tx, ty, tz);
revRotMat = getRevRotMat(tx, ty, tz);
[Ns Ms d] = size(src);
[Nm Mm d] = size(map);
rotSrc = zeros(Ns, Ms, 3);
rotMap = zeros(Nm, Mm, 3);
tmp = zeros(3, 1);
ntmp = zeros(3, 1);
% Rotate src and map
for i = 1 : Ns
    for j = 1 : Ms
        for k = 1 : 3
            tmp(k) = src(i, j, k);
        end
        ntmp = rotMat * tmp;
        for k = 1 : 3
            rotSrc(i, j, k) = ntmp(k);
        end
    end
end
for i = 1 : Nm
    for j = 1 : Mm
        for k = 1 : 3
            tmp(k) = map(i, j, k);
        end
        ntmp = rotMat * tmp;
        for k = 1 : 3
            rotMap(i, j, k) = ntmp(k);
        end
    end
end
MAX = floor(255 * sqrt(3)) + 1;
L = 2 * MAX + 1;
sHist = zeros(L, 3);
mHist = zeros(L, 3);
% Calculate hist
for i = 1 : Ns
    for j = 1 : Ms
        if sfilter(i, j)
            for k = 1 : 3
                sHist(floor(rotSrc(i, j, k)) + MAX, k) = sHist(floor(rotSrc(i, j, k)) + MAX, k) + 1;
            end
        end
    end
end
for i = 1 : Nm
    for j = 1 : Mm
        if mfilter(i, j)
            for k = 1 : 3
                mHist(floor(rotMap(i, j, k)) + MAX, k) = mHist(floor(rotMap(i, j, k)) + MAX, k) + 1;
            end
        end
    end
end

% Calculate CDF
for i = 2 : L
    for j = 1 : 3
        sHist(i, j) = sHist(i - 1, j) + sHist(i, j);
        mHist(i, j) = mHist(i - 1, j) + mHist(i, j);
    end
end
% Convert to percentage
sHist = sHist / sHist(L, 1);
mHist = mHist / mHist(L, 1);

%sHist = sHist / (Ns * Ms);
%mHist = mHist / (Nm * Mm);

% Get transform function
transform = zeros(L, 3);
for d = 1 : 3
    ind = 1;
    for i = 1 : L
        while mHist(ind, d) < sHist(i, d)
            ind = ind + 1;
        end
        transform(i, d) = ind - MAX;
    end
end

% Actually do the transform
for i = 1 : Ns
    for j = 1 : Ms
        if sfilter(i, j)
            for k = 1 : 3
                rotSrc(i, j, k) = transform(floor(rotSrc(i, j, k)) + MAX, k);
            end
        end
    end
end
out = zeros(Ns, Ms, 3);
for i = 1 : Ns
    for j = 1 : Ms
        if sfilter(i, j)
            for k = 1 : 3
                tmp(k) = rotSrc(i, j, k);
            end
            ntmp = revRotMat * tmp;
            for k = 1 : 3
                out(i, j, k) = ntmp(k);
            end
        else
            for k = 1 : 3
                out(i, j, k) = src(i, j, k);
            end
        end
    end
end

end

