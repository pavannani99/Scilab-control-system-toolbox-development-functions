// Copyright (C) 2026
// Scilab translation for FOSSEE Control Systems Toolbox
//
// Function: __sys_group__
// Octave source: @ss/__sys_group__.m
//
// Description:
//     Block diagonal concatenation of two state-space models.
//     This file is for internal use by blkdiag.
//
// Dependencies:
//     __numeric_to_lti__.sci
//     __lti_group__.sci

function retsys = __sys_group__(sys1, sys2)

    // If one system is just a numeric value, create a proper LTI system.
    [sys1, sys2] = __numeric_to_lti__(sys1, sys2);

    if typeof(sys1) <> "state-space" then
        sys1 = tf2ss(sys1);
    end

    if typeof(sys2) <> "state-space" then
        sys2 = tf2ss(sys2);
    end

    dt = __lti_group__(sys1, sys2);

    a1 = sys1.A;
    b1 = sys1.B;
    c1 = sys1.C;
    d1 = sys1.D;

    a2 = sys2.A;
    b2 = sys2.B;
    c2 = sys2.C;
    d2 = sys2.D;

    n1 = size(a1, 1);
    n2 = size(a2, 1);

    [p1, m1] = size(d1);
    [p2, m2] = size(d2);

    // Preserve the correct B and C dimensions for static-gain systems.
    if n1 == 0 then
        a1 = zeros(0, 0);
        b1 = zeros(0, m1);
        c1 = zeros(p1, 0);
    end

    if n2 == 0 then
        a2 = zeros(0, 0);
        b2 = zeros(0, m2);
        c2 = zeros(p2, 0);
    end

    a = [a1, zeros(n1, n2);
         zeros(n2, n1), a2];

    b = [b1, zeros(n1, m2);
         zeros(n2, m1), b2];

    c = [c1, zeros(p1, n2);
         zeros(p2, n1), c2];

    d = [d1, zeros(p1, m2);
         zeros(p2, m1), d2];

    retsys = syslin(dt, a, b, c, d);

endfunction
