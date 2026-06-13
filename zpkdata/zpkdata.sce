funcprot(0);

function r = __zpkdata_roots__(p)
    c = coeff(p);

    while length(c) > 1 & abs(c($)) <= %eps
        c($) = [];
    end

    if length(c) <= 1 then
        r = [];
    else
        r = roots(p);
    end
endfunction

function g = __zpkdata_gain__(num, den)
    cn = coeff(num);
    cd = coeff(den);

    while length(cn) > 1 & abs(cn($)) <= %eps
        cn($) = [];
    end

    while length(cd) > 1 & abs(cd($)) <= %eps
        cd($) = [];
    end

    if length(cn) == 1 & cn(1) == 0 then
        g = 0;
    else
        g = cn($) / cd($);
    end
endfunction

function [z, p, k, tsam] = zpkdata(sys, flg)

    rhs = argn(2);

    if rhs < 1 then
        error("zpkdata: Wrong number of input arguments. At least one input argument expected.");
    end

    if rhs > 2 then
        error("zpkdata: Wrong number of input arguments. At most two input arguments expected.");
    end

    if rhs == 1 then
        flg = "";
    end

    if flg <> "" & flg <> "v" then
        error("zpkdata: Second argument must be ""v"".");
    end

    typ = typeof(sys);

    if typ == "state-space" then
        sys = ss2tf(sys);
        typ = typeof(sys);
    end

    if typ <> "rational" then
        error("zpkdata: Input argument must be an LTI system.");
    end

    num = sys.num;
    den = sys.den;
    tsam = sys.dt;

    [ny, nu] = size(num);

    k = zeros(ny, nu);
    z = list();
    p = list();

    for i = 1:ny
        for j = 1:nu
            idx = (i - 1) * nu + j;
            z(idx) = __zpkdata_roots__(num(i, j));
            p(idx) = __zpkdata_roots__(den(i, j));
            k(i, j) = __zpkdata_gain__(num(i, j), den(i, j));
        end
    end

    if flg == "v" then
        if ny <> 1 | nu <> 1 then
            error("zpkdata: The ""v"" option is only valid for SISO systems.");
        end

        z = z(1);
        p = p(1);
        k = k(1, 1);
    end

endfunction
