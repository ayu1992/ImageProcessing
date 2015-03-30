function output = hisEq(img1,img2)    
    img1 = imread(img1);
    img2 = imread(img2);
    cdf_r1 = getCDF(img1(:,:,1));
    cdf_r2 = getCDF(img2(:,:,1));
    cdf_g1 = getCDF(img1(:,:,2));
    cdf_g2 = getCDF(img2(:,:,2));
    cdf_b1 = getCDF(img1(:,:,3));
    cdf_b2 = getCDF(img2(:,:,3));
    
    Tr = equalization(cdf_r1,cdf_r2);
    Tg = equalization(cdf_g1,cdf_g2);
    Tb = equalization(cdf_b1,cdf_b2);
    
    T = cat(3,Tr,Tg,Tb);
%   tmr = TMR(T,img1,img2);
    [N,M,d] = size(img1);
    eimg = zeros(N,M,d);
    for i = 1 : N
        for j = 1: M
            eimg(i,j,1) = Tr(img1(i,j,1)+1);
            eimg(i,j,2) = Tg(img1(i,j,2)+1);
            eimg(i,j,3) = Tb(img1(i,j,3)+1);
        end
    end
    imshow(uint8(eimg),[]);
    
end
function output = TMR(T,img1,img2)
    [N,M,d] = size(img1);
    % M(u) = T(u) - u
    size(T)
    for i = 1: N 
        for j = 1: M
        m(i,j,:) = T(img1(i,j,:)+1) - double(img1(i,j,:));
        end
    end
   
    y = 0;
    % YuM(u) 
        X = [-1,0,1];
        Y = [-1,0,1];
        % C(x)
        for x = 1: N
            for y = 1: M
                for i = 1: 3
                    for j = 1:3
                y = y + constant(x+X(i),y+Y(j),img1);
                    end
                end
            end
        end
end
function output = constant(x,y,img1)
    [N,M] = size(img1);
    c = 0;
     sigma = 0.1;
    X = [-1,0,1];
    Y = [-1,0,1];
    u1 = img1(x,y,:);
    for i = 1 : 3
        for j = 1 : 3
        u2 = img1(x+X(i),y+Y(j),:);
        c = c + exp(-(u1-u2)'*(u1-u2)/sigma^2);
        end
    end
end
function output = equalization(cdf1,cdf2)                   % get T
    T = zeros(256,1);
    j = 1;
    for i = 1:256
        while(cdf2(j) < cdf1(i))
          j = j+ 1; 
        end
        T(i) = j;
    end
    %f = figure();plot(T);title('T');
    output = T;
end
function output = getCDF(img)
    [N,M] = size(img);
    pr = zeros(256);
    for i = 1:N
        for j = 1:M
            pr(img(i,j)+1) = pr(img(i,j)+1) + 1;
        end
    end
    pr = pr / (M*N);                                    % adds to 1 , ok
    
    % cdf 
    s_k = zeros(256);
    sum = pr(1);
    for k = 2 : size(pr)
        sum = sum + pr(k);
        s_k(k) = round(255*sum);
    end
    x = linspace(0,255,256);                           
    %f = figure();plot(x,s_k);title('cdf');
    output = s_k;
end