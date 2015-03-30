function out = hisEqNew( img, map )
N = 9;
[Ns, Ms, ds] = size(img);
[Nm, Mm, dm] = size(map);
f1 = ones(Ns, Ms);
f2 = ones(Nm, Mm);
%img = rgb2lab(img);
%map = rgb2lab(map);
out = hisEqIter(img, map, 0, 0, 0, f1, f2);
figure;
subplot(3, 4, 1); imshow(uint8(img));
subplot(3, 4, 2); imshow(uint8(out));
for i = 1 : N
    t1 = rand() * pi / 2; 
    t2 = rand() * pi / 2; 
    t3 = rand() * pi / 2;
    out = hisEqIter(out, map, t1, t2, t3, f1, f2);
    out = hisEqIter(out, map, t2, t3, t1, f1, f2);
    out = hisEqIter(out, map, t3, t1, t2, f1, f2);
    out = hisEqIter(out, map, t1, t3, t2, f1, f2);
    out = hisEqIter(out, map, t3, t2, t1, f1, f2);
    out = hisEqIter(out, map, t2, t1, t3, f1, f2);
    subplot(3, 4, i + 2); imshow(uint8(out));
    disp(i);
end
subplot(3, 4, 12); imshow(uint8(map));
end

