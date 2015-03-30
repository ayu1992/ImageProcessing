function out = lab2rgb(img)
[N, M, d] = size(img);
out = zeros(N, M, d);
tmp = zeros(3, 1);
lL = [1 1 1;1 1 -1;1 -2 0] * diag([sqrt(3)/3 sqrt(6)/6 sqrt(2)/2]);
LR = [4.4679 -3.5873 0.1193;
    -1.2186 2.3809 -0.1624;
    0.0497 -0.2439 1.2045];
for i = 1 : N
    for j = 1 : M
        tmp(1) = img(i, j, 1);
        tmp(2) = img(i, j, 2);
        tmp(3) = img(i, j, 3);
        LMS = lL * tmp;
        tmp = LR * exp(LMS);
        out(i, j, 1) = tmp(1);
        out(i, j, 2) = tmp(2);
        out(i, j, 3) = tmp(3);
    end
end


end

