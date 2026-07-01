// Copyright (C) 2026
// Scilab translation for FOSSEE Control Systems Toolbox
//
// Function: __numeric_to_lti__
// Octave source: @lti/__numeric_to_lti__.m
//
// Description:
//     Checks two systems that have to be connected and converts numerical
//     values into proper LTI static-gain systems.
//     This file is for internal use by blkdiag.

function [sys1, sys2] = __numeric_to_lti__(sys1, sys2)

    if ~__blkdiag_is_lti__(sys1) then
        if typeof(sys1) <> "constant" then
            error("lti: blkdiag: one system is neither an lti system nor a numeric value");
        else
            sys1 = __blkdiag_numeric_to_static_lti__(sys1, sys2);
        end
    end

    if ~__blkdiag_is_lti__(sys2) then
        if typeof(sys2) <> "constant" then
            error("lti: blkdiag: one system is neither an lti system nor a numeric value");
        else
            sys2 = __blkdiag_numeric_to_static_lti__(sys2, sys1);
        end
    end

    if typeof(sys1) == "rational" then
        sys1 = tf2ss(sys1);
    end

    if typeof(sys2) == "rational" then
        sys2 = tf2ss(sys2);
    end

    // If one of the systems is only a continuous static gain and the other
    // system is discrete, take the sampling domain of the other system.
    if __blkdiag_is_static_gain__(sys1) & __blkdiag_is_continuous__(sys1) & __blkdiag_is_discrete__(sys2) then
        sys1 = syslin(sys2.dt, [], [], [], sys1.D);
    elseif __blkdiag_is_static_gain__(sys2) & __blkdiag_is_continuous__(sys2) & __blkdiag_is_discrete__(sys1) then
        sys2 = syslin(sys1.dt, [], [], [], sys2.D);
    end

endfunction


function flag = __blkdiag_is_lti__(sys)

    flag = (typeof(sys) == "state-space") | (typeof(sys) == "rational");

endfunction


function sys = __blkdiag_numeric_to_static_lti__(gain_matrix, other_sys)

    dt = "c";

    if __blkdiag_is_lti__(other_sys) then
        if typeof(other_sys) == "rational" then
            other_sys = tf2ss(other_sys);
        end
        dt = other_sys.dt;
    end

    sys = syslin(dt, [], [], [], gain_matrix);

endfunction


function flag = __blkdiag_is_static_gain__(sys)

    if typeof(sys) == "rational" then
        sys = tf2ss(sys);
    end

    if typeof(sys) <> "state-space" then
        flag = %f;
        return;
    end

    flag = isempty(sys.A) | (size(sys.A, 1) == 0) | (size(sys.A, 2) == 0);

endfunction


function flag = __blkdiag_is_continuous__(sys)

    if typeof(sys) == "rational" then
        sys = tf2ss(sys);
    end

    flag = (typeof(sys.dt) == "string" & sys.dt == "c");

endfunction


function flag = __blkdiag_is_discrete__(sys)

    if typeof(sys) == "rational" then
        sys = tf2ss(sys);
    end

    if typeof(sys.dt) == "string" then
        flag = (sys.dt <> "c");
    else
        flag = %t;
    end

endfunction
