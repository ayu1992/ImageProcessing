function out = TMRmain( u, Tu )
  NN = 2; % number of neighbors = (2 * N + 1) ^ 2
  SS = 10 * 10; % sigma sq
  N_ITER = 10;
  C = computeC(u, NN, SS);
  out = Tu;
  figure;
  for i = 1 : N_ITER
      disp(i);
      subplot(3, 4, i);
      imshow(uint8(out));
      last = out;
      out = TMRiter(u, out, C, NN, SS);
      sum(last - out)
  end
end

function C = computeC(u, n, ss)
  [N, M, d] = size(u);
  C = zeros(N, M);
  for i = 1 : N
      for j = 1 : M
          for ii = max(1, i - n) : min(N, i + n)
              for jj = max(1, j - n) : min(M, j + n)
                  C(i, j) = C(i, j) + exp(-sum((u(i, j, :) - u(ii, jj, :)) .^ 2) / ss);
              end
          end
      end
  end
end

function T = TMRiter(u, Tu, C, n, ss)
  [N, M, d] = size(u);
  T = zeros(N, M, d);
  Mu = Tu - double(u);
  for i = 1 : N
      for j = 1 : M
          T(i, j, :) = u(i, j, :);
          for ii = max(1, i - n) : min(N, i + n)
              for jj = max(1, j - n) : min(M, j + n)
                  T(i, j, :) = T(i, j, :) + (1 / C(i, j)) * Mu(i, j, :) * exp(-sum((u(i, j, :) - u(ii, jj, :)) .^ 2) / ss);
              end
          end
      end
  end
end
