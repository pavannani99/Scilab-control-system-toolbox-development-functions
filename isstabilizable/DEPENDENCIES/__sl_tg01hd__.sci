// DEPENDENCY
// octave slicot routine: https://sourceforge.net/p/octave/control/ci/default/tree/src/sl_tg01hd.cc
//
// IMPORTANT LIMITATION - READ BEFORE USING WITH SINGULAR E:
// The Octave source is a C++ wrapper around the Fortran SLICOT routine TG01HD,
// which computes a controllability staircase form for a descriptor system
// (A, E, B, C) using coordinated left (Q) and right (Z) transformations that
// correctly account for E's structure, including singular/infinite dynamics.
//
// This reimplementation applies a single orthogonal similarity transform T to
// both A and E (T'*A*T, T'*E*T), which exactly preserves the pencil's finite
// generalized eigenvalues (spec(A,E) is invariant under similarity). However,
// the deflation/rank decision driving the staircase is based only on B's
// column structure -- exactly the same logic as the non-descriptor case in
// __sl_ab01od__ -- and does NOT use E's structure to determine controllability.
// For E = identity (or any nonsingular E), this reduces correctly to the
// standard case. For a genuinely SINGULAR E, this is not a validated
// algorithm and may produce incorrect controllable/uncontrollable splits.
//
// A rank check on E is included below to surface this loudly (as a warning)
// rather than fail silently. Do not treat results from a singular-E call as
// trustworthy until this is validated against known descriptor test systems
// or replaced with a proper QZ/generalized-Schur-based implementation.
//
// Also dropped vs. the real TG01HD signature: NIUCON, NRBLCK, RTAU (multi-block
// staircase structure). isstabilizable.sci only consumes ncont, so nothing
// breaks here, but this file is not a complete port of TG01HD.
function [ac, ec, bc, cc, q, z, ncont] = __sl_tg01hd__ (a, e, b, c, tol)
    n = size(a, 1);
    m = size(b, 2);
    p = size(c, 1);

    // Surface the singular-E limitation instead of failing silently
    if tol > 0 then
        e_rank = rank(e, tol);
    else
        e_rank = rank(e);
    end
    if e_rank < n then
        warning("__sl_tg01hd__: E is singular (rank " + string(e_rank) + " < " + string(n) + "); this reimplementation is not validated for singular descriptor matrices - results may be incorrect.");
    end

    ac = a;
    ec = e;
    bc = b;
    cc = c;
    q = eye(n, n);
    z = eye(n, n);
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
        ec = Qfull' * ec * Qfull;
        bc = Qfull' * bc;
        cc = cc * Qfull;
        q  = q * Qfull;
        z  = z * Qfull;
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
    ec = ec(1:n, 1:n);
    bc = bc(1:n, 1:m);
    cc = cc(1:p, 1:n);
    q  = q(1:n, 1:n);
    z  = z(1:n, 1:n);
endfunction
