// DEPENDENCY
// octave slicot routine: https://sourceforge.net/p/octave/control/ci/default/tree/src/sl_ab01od.cc
function [ac, bc, u, ncont] = __sl_ab01od__ (a, b, tol)
    n = size(a, 1);
    m = size(b, 2);
    ac = a;
    bc = b;
    u = eye(n, n);
    ncont = 0;
    ioff = 0;
    Bcur = bc;
    while %t
        if (ioff >= n) then
            break;
        end
        block = Bcur(ioff+1:n, :);
        if (norm(block, 1) <= max(tol, %eps * norm(a, 1))) then
            break;
        end
        [Q, R, E] = qr(block);
        if (tol > 0) then
            rk = sum(abs(diag(R)) > tol);
        else
            dr = abs(diag(R));
            if (isempty(dr)) then
                rk = 0;
            else
                rtol = %eps * max(size(block)) * max(dr);
                rk = sum(dr > rtol);
            end
        end
        if (rk == 0) then
            break;
        end
        Qfull = eye(n, n);
        Qfull(ioff+1:n, ioff+1:n) = Q;
        ac = Qfull' * ac * Qfull;
        bc = Qfull' * bc;
        u  = u * Qfull;
        ncont = min(ncont + rk, n);
        ioff = ioff + rk;
        Bcur = ac;
        Bcur = Bcur(:, 1:min(m, n));
        Bcur(1:ioff, :) = 0;
        if (ioff < n) then
            Bcur = ac(:, ioff-rk+1:ioff);
            tmp = zeros(n, size(Bcur,2));
            tmp(ioff+1:n, :) = ac(ioff+1:n, ioff-rk+1:ioff);
            Bcur = tmp;
        end
    end
    ac = ac(1:n, 1:n);
    bc = bc(1:n, 1:m);
    u  = u(1:n, 1:n);
endfunction
