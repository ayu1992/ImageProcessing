function out = rgb2lab(img)
[N, M, d] = size(img);
out = zeros(N, M, 3);
tmp = zeros(3, 1);
RL = [.3811 .5783 .0402;
            .1967 .7244 .0782;
            .0241 .1288 .8444];
Ll = diag([1/sqrt(3) 1/sqrt(6) 1/sqrt(2)]) * [1 1 1;1 1 -2;1 -1 0];        
for i = 1 : N
    for j = 1 : M
        tmp(1) = img(i, j, 1);
        tmp(2) = img(i, j, 2);
        tmp(3) = img(i, j, 3);
        lms = RL * tmp + 0.01;
        tmp = Ll * log(lms);
        out(i, j, 1) = tmp(1);
        out(i, j, 2) = tmp(2);
        out(i, j, 3) = tmp(3);
    end
end

end

