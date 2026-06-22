/* Copyright (C) 2009-2016 Lukas F. Reichlin */
/* 2026 Scilab translation: Simhadri Pavan kumar*/

/*
Submodel extraction and channel reordering for Scilab LTI systems.
Repeated output and input indices are allowed, which is required by repmat.
*/

funcprot(0);

function sys = __sys_prune__(sys, out_idx, in_idx)

    select typeof(sys)
    case "rational" then
        sys.num = sys.num(out_idx, in_idx);
        sys.den = sys.den(out_idx, in_idx);

    case "state-space" then
        sys.B = sys.B(:, in_idx);
        sys.C = sys.C(out_idx, :);
        sys.D = sys.D(out_idx, in_idx);

    else
        error("__sys_prune__: input argument must be an LTI system");
    end

endfunction
