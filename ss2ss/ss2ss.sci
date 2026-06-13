funcprot(0);

function r = __ss2ss_rank__(M)
    sv = svd(M);

    if size(sv, "*") == 0 then
        r = 0;
        return;
    end

    mx = max(sv);

    if mx == 0 then
        r = 0;
    else
        tol = max(size(M)) * mx * %eps * 1d4;
        r = size(find(sv > tol), "*");
    end
endfunction

function __ss2ss_check_matrix__(M, name)
    if typeof(M) <> "constant" then
        error("ss2ss: " + name + " must be a numeric matrix.");
    end
endfunction

function [At, Bt, Ct, Dt] = __ss2ss_transform__(A, B, C, D, T)

    __ss2ss_check_matrix__(A, "A");
    __ss2ss_check_matrix__(B, "B");
    __ss2ss_check_matrix__(C, "C");
    __ss2ss_check_matrix__(D, "D");
    __ss2ss_check_matrix__(T, "T");

    [na, ma] = size(A);

    if na <> ma then
        error("ss2ss: A must be a square matrix.");
    end

    n = na;

    if size(B, 1) <> n then
        error("ss2ss: B must have the same number of rows as A.");
    end

    if size(C, 2) <> n then
        error("ss2ss: C must have the same number of columns as A.");
    end

    if size(D, 1) <> size(C, 1) then
        error("ss2ss: D must have the same number of rows as C.");
    end

    if size(D, 2) <> size(B, 2) then
        error("ss2ss: D must have the same number of columns as B.");
    end

    if size(T, 1) <> n | size(T, 2) <> n then
        error("ss2ss: T must be a square matrix with the same order as A.");
    end

    if __ss2ss_rank__(T) < n then
        error("ss2ss: Transformation matrix T must be nonsingular.");
    end

    At = T * A / T;
    Bt = T * B;
    Ct = C / T;
    Dt = D;

endfunction

function varargout = ss2ss(varargin)

    [lhs, rhs] = argn(0);

    if rhs == 2 then

        if lhs > 1 then
            error("ss2ss: Wrong number of output arguments.");
        end

        sys = varargin(1);
        T = varargin(2);

        if typeof(sys) <> "state-space" then
            error("ss2ss: First input must be a state-space system.");
        end

        A = sys.A;
        B = sys.B;
        C = sys.C;
        D = sys.D;

        [At, Bt, Ct, Dt] = __ss2ss_transform__(A, B, C, D, T);

        varargout(1) = syslin(sys.dt, At, Bt, Ct, Dt);

    elseif rhs == 5 then

        if lhs <> 4 then
            error("ss2ss: Four output arguments are required for matrix input form.");
        end

        A = varargin(1);
        B = varargin(2);
        C = varargin(3);
        D = varargin(4);
        T = varargin(5);

        [At, Bt, Ct, Dt] = __ss2ss_transform__(A, B, C, D, T);

        varargout(1) = At;
        varargout(2) = Bt;
        varargout(3) = Ct;
        varargout(4) = Dt;

    else

        error("ss2ss: Wrong number of input arguments.");

    end

endfunction
