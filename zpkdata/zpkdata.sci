funcprot(0);

function c = __zpkdata_coeff__(p)
    if typeof(p) == "constant" then
        c = p;
    else
        c = coeff(p);
    end
endfunction

function c = __zpkdata_trim__(c)
    if size(c, "*") == 0 then
        c = 0;
        return;
    end

    while length(c) > 1 & abs(c($)) <= %eps
        c($) = [];
    end
endfunction

function r = __zpkdata_roots__(p)
    c = __zpkdata_coeff__(p);
    c = __zpkdata_trim__(c);

    if length(c) <= 1 then
        r = [];
    else
        r = roots(p);
    end
endfunction

function g = __zpkdata_gain__(num, den)
    cn = __zpkdata_coeff__(num);
    cd = __zpkdata_coeff__(den);

    cn = __zpkdata_trim__(cn);
    cd = __zpkdata_trim__(cd);

    if length(cd) == 1 & abs(cd(1)) <= %eps then
        error("zpkdata: Denominator cannot be zero.");
    end

    if length(cn) == 1 & abs(cn(1)) <= %eps then
        g = 0;
    else
        g = cn($) / cd($);
    end
endfunction

function sys_tf = __zpkdata_to_tf__(sys)
    typ = typeof(sys);

    if typ == "rational" then
        sys_tf = sys;
    elseif typ == "state-space" then
        sys_tf = ss2tf(sys);
    else
        error("zpkdata: Input argument must be an LTI system.");
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

    if typeof(flg) <> "string" then
        error("zpkdata: Second argument must be a string.");
    end

    flg = convstr(flg, "l");

    if flg <> "" & flg <> "v" then
        error("zpkdata: Second argument must be ""v"".");
    end

    sys = __zpkdata_to_tf__(sys);

    num = sys.num;
    den = sys.den;
    tsam = sys.dt;

    [ny, nu] = size(num);

    if flg == "v" then
        if ny <> 1 | nu <> 1 then
            error("zpkdata: The ""v"" option is only valid for SISO systems.");
        end

        z = __zpkdata_roots__(num(1, 1));
        p = __zpkdata_roots__(den(1, 1));
        k = __zpkdata_gain__(num(1, 1), den(1, 1));

    else
        z = list();
        p = list();
        k = zeros(ny, nu);

        for i = 1:ny
            for j = 1:nu
                idx = (i - 1) * nu + j;
                z(idx) = __zpkdata_roots__(num(i, j));
                p(idx) = __zpkdata_roots__(den(i, j));
                k(i, j) = __zpkdata_gain__(num(i, j), den(i, j));
            end
        end
    end

endfunction
