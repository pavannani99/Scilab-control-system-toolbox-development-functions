funcprot(0);

function retval = is_real_matrix(sys)

```
retval = 0;

if typeof(sys) == "constant" then
    if size(sys, "*") >= 1 then
        if max(abs(imag(sys))) == 0 then
            retval = 1;
        end
    end
end
```

endfunction

function p = **remove_leading_zeros**(p)

```
if typeof(p) <> "constant" then
    p = coeff(p);
else
    p = matrix(p, 1, -1);
end

p = p($:-1:1);

while length(p) > 1 & abs(p(1)) <= %eps
    p(1) = [];
end
```

endfunction

function [z, p, k, tsam] = zpkdata(sys, rtype)

```
[lhs, rhs] = argn(0);

if rhs < 1 | rhs > 2 then
    error("zpkdata: wrong number of input arguments");
end

if rhs == 1 then
    rtype = "cell";
end

if typeof(sys) <> "rational" & typeof(sys) <> "state-space" then

    if ~is_real_matrix(sys) then
        error(["zpkdata: has to be called with an @lti object ", "or with a real matrix (static gain)"]);
    else
        num = sys;
        den = ones(size(sys, 1), size(sys, 2));
        tsam = 0;
    end

else

    if typeof(sys) == "state-space" then
        sys = ss2tf(sys);
    end

    num = sys.num;
    den = sys.den;
    tsam = sys.dt;

    if typeof(tsam) == "string" then
        if tsam == "c" then
            tsam = 0;
        else
            tsam = -1;
        end
    end

end

[ny, nu] = size(num);

z = list();
p = list();
k = zeros(ny, nu);

for i = 1:ny
    for j = 1:nu

        idx = (i - 1) * nu + j;

        n = __remove_leading_zeros__(num(i, j));
        d = __remove_leading_zeros__(den(i, j));

        if length(n) <= 1 then
            z(idx) = zeros(0, 1);
        else
            z(idx) = roots(poly(n($:-1:1), "x", "coeff"));
        end

        if length(d) <= 1 then
            p(idx) = zeros(0, 1);
        else
            p(idx) = roots(poly(d($:-1:1), "x", "coeff"));
        end

        k(i, j) = n(1) / d(1);

    end
end

if typeof(rtype) <> "string" then
    error("zpkdata: second argument must be a string");
end

if length(rtype) >= 1 then
    if convstr(part(rtype, 1), "l") == "v" then

        if ny <> 1 | nu <> 1 then
            error("zpkdata: vector output is possible only for SISO systems");
        end

        z = z(1);
        p = p(1);

    end
end
```

endfunction
