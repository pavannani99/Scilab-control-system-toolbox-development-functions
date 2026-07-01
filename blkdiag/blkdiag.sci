// Copyright (C) 2026
// Scilab translation for FOSSEE Control Systems Toolbox
//
// Function: blkdiag
// Description: Block-diagonal concatenation of LTI models.

function sys = blkdiag(varargin)
    [lhs, rhs] = argn(0);
    if rhs < 1 then
        error("blkdiag: at least one system argument required");
    end
    sys = varargin(1);
    for k = 2:rhs
        sys = __sys_group__(sys, varargin(k));
    end
endfunction

// -----------------------------------------------------------------------------
// Simplified Test Suite
// Run using: exec("blkdiag.sci", -1); blkdiag_test_simplified();
// -----------------------------------------------------------------------------

function blkdiag_test_simplified()
    A1 = [0, 1; -2, -3]; B1 = [0; 1]; C1 = [1, 0]; D1 = 0;
    sys1 = syslin("c", A1, B1, C1, D1);
    A2 = [-4]; B2 = [2]; C2 = [3]; D2 = 1;
    sys2 = syslin("c", A2, B2, C2, D2);

    // Test 1: Continuous-time concatenation
    sys = blkdiag(sys1, sys2);
    disp("Test 1: " + string(norm(sys.A - [A1, [0;0]; [0,0], A2]) < 1d-8));

    // Test 2: Multiple systems (3 systems)
    sys3 = syslin("c", [-5], [1], [2], 3);
    sys_all = blkdiag(sys1, sys2, sys3);
    disp("Test 2: " + string(size(sys_all.A, 1) == 4));

    // Test 3: Single system input
    sys_single = blkdiag(sys1);
    disp("Test 3: " + string(norm(sys_single.A - A1) < 1d-8));

    // Test 4: Static gain concatenation
    K = [5, 6];
    sys_static = blkdiag(sys1, K);
    disp("Test 4: " + string(size(sys_static.D, 2) == 3));

    // Test 5: Discrete-time concatenation
    dsys1 = syslin(0.1, [0.5], [1], [2], [0]);
    dsys2 = syslin(0.1, [0.25], [3], [4], [1]);
    dsys = blkdiag(dsys1, dsys2);
    disp("Test 5: " + string(norm(dsys.A - [0.5, 0; 0, 0.25]) < 1d-8));

    // Test 6: Mismatched Sampling Time (Expected Error)
    err6 = %f; try, blkdiag(sys1, dsys1); catch, err6 = %t; end
    disp("Test 6: " + string(err6));

    // Test 7: Invalid Input Type (Expected Error)
    err7 = %f; try, blkdiag(sys1, "invalid"); catch, err7 = %t; end
    disp("Test 7: " + string(err7));
endfunction
