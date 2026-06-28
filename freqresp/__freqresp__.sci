// Copyright (C) 2026
// Scilab translation for FOSSEE Control Systems Toolbox
//
// Frequency response helper for state-space/rational LTI systems.
// Based on the Octave Control package internal function:
//     __freqresp__
//
// For internal use only.

function H = __freqresp__(sys, w, cellflag)

    rhs = argn(2);

    if rhs < 2 then
        error("__freqresp__: wrong number of input arguments");
    end

    if rhs < 3 then
        cellflag = %f;
    end

    if cellflag then
        error("__freqresp__: cell output is not supported in this Scilab translation");
    end

    if typeof(sys) == "rational" then
        sys = tf2ss(sys);
    elseif typeof(sys) <> "state-space" then
        error("__freqresp__: first argument must be an LTI system");
    end

    a = sys.A;
    b = sys.B;
    c = sys.C;
    d = sys.D;

    [p, m] = size(d);
    n = size(a, 1);

    w = matrix(w, 1, -1);
    nw = length(w);

    H = zeros(p, m, nw);

    if n == 0 then
        for k = 1:nw
            H(:, :, k) = d;
        end
        return;
    end

    if __freqresp_isct__(sys) then
        s = %i * w;
    else
        tsam = __freqresp_tsam__(sys);
        s = exp(%i * w * abs(tsam));
    end

    e = eye(n, n);

    for k = 1:nw
        H(:, :, k) = c * ((s(k) * e - a) \ b) + d;
    end

endfunction


function flag = __freqresp_isct__(sys)

    dt = sys.dt;

    if typeof(dt) == "string" then
        flag = (dt == "c");
    else
        flag = %f;
    end

endfunction


function tsam = __freqresp_tsam__(sys)

    dt = sys.dt;

    if typeof(dt) == "string" then
        if dt == "c" then
            tsam = 0;
        else
            // Scilab's "d" domain does not always store a numeric sample time.
            // Use unit sampling time, matching z = exp(i*w) for unspecified Ts.
            tsam = 1;
        end
    else
        tsam = dt;
    end

endfunction
