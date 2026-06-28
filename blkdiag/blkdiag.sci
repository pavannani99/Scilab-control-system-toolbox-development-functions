// Copyright (C) 2026
// Scilab translation for FOSSEE Control Systems Toolbox
//
// Function: blkdiag
// Octave source: @lti/blkdiag.m
//
// Calling Sequence:
//     sys = blkdiag(sys1, sys2, ..., sysN)
//
// Description:
//     Block-diagonal concatenation of LTI models.
//
// Dependencies:
//     __sys_group__.sci
//     __numeric_to_lti__.sci
//     __lti_group__.sci

function sys = blkdiag(varargin)

    sys = varargin(1);

    for k = 2:argn(2)
        sys = __sys_group__(sys, varargin(k));
    end

endfunction


// -----------------------------------------------------------------------------
// Test cases
// Run manually using:
// exec("__numeric_to_lti__.sci", -1);
// exec("__lti_group__.sci", -1);
// exec("__sys_group__.sci", -1);
// exec("blkdiag.sci", -1);
// blkdiag_test();
// -----------------------------------------------------------------------------

function blkdiag_test()

    disp("Running blkdiag test cases...");

    // Test Case 1: block diagonal concatenation of two continuous-time systems
    A1 = [0, 1; -2, -3];
    B1 = [0; 1];
    C1 = [1, 0];
    D1 = 0;
    sys1 = syslin("c", A1, B1, C1, D1);

    A2 = [-4];
    B2 = [2];
    C2 = [3];
    D2 = 1;
    sys2 = syslin("c", A2, B2, C2, D2);

    sys = blkdiag(sys1, sys2);

    A_expected = [A1, zeros(2, 1);
                  zeros(1, 2), A2];

    B_expected = [B1, zeros(2, 1);
                  zeros(1, 1), B2];

    C_expected = [C1, zeros(1, 1);
                  zeros(1, 2), C2];

    D_expected = [D1, zeros(1, 1);
                  zeros(1, 1), D2];

    __blkdiag_assert_close__(sys.A, A_expected, "Test Case 1: A matrix block diagonal passed");
    __blkdiag_assert_close__(sys.B, B_expected, "Test Case 1: B matrix block diagonal passed");
    __blkdiag_assert_close__(sys.C, C_expected, "Test Case 1: C matrix block diagonal passed");
    __blkdiag_assert_close__(sys.D, D_expected, "Test Case 1: D matrix block diagonal passed");

    // Test Case 2: block diagonal concatenation of three systems
    A3 = [-5];
    B3 = [1];
    C3 = [2];
    D3 = 3;
    sys3 = syslin("c", A3, B3, C3, D3);

    sys_all = blkdiag(sys1, sys2, sys3);

    A_expected = [A1, zeros(2, 1), zeros(2, 1);
                  zeros(1, 2), A2, zeros(1, 1);
                  zeros(1, 2), zeros(1, 1), A3];

    B_expected = [B1, zeros(2, 1), zeros(2, 1);
                  zeros(1, 1), B2, zeros(1, 1);
                  zeros(1, 1), zeros(1, 1), B3];

    C_expected = [C1, zeros(1, 1), zeros(1, 1);
                  zeros(1, 2), C2, zeros(1, 1);
                  zeros(1, 2), zeros(1, 1), C3];

    D_expected = [D1, 0, 0;
                  0, D2, 0;
                  0, 0, D3];

    __blkdiag_assert_close__(sys_all.A, A_expected, "Test Case 2: multiple-system A matrix passed");
    __blkdiag_assert_close__(sys_all.B, B_expected, "Test Case 2: multiple-system B matrix passed");
    __blkdiag_assert_close__(sys_all.C, C_expected, "Test Case 2: multiple-system C matrix passed");
    __blkdiag_assert_close__(sys_all.D, D_expected, "Test Case 2: multiple-system D matrix passed");

    // Test Case 3: one input argument returns the same system data
    sys_single = blkdiag(sys1);

    __blkdiag_assert_close__(sys_single.A, A1, "Test Case 3: single input A matrix passed");
    __blkdiag_assert_close__(sys_single.B, B1, "Test Case 3: single input B matrix passed");
    __blkdiag_assert_close__(sys_single.C, C1, "Test Case 3: single input C matrix passed");
    __blkdiag_assert_close__(sys_single.D, D1, "Test Case 3: single input D matrix passed");

    // Test Case 4: numeric static-gain input converted to LTI system
    K = [5, 6];
    sys_static = blkdiag(sys1, K);

    A_expected = A1;
    B_expected = [B1, zeros(2, 2)];
    C_expected = [C1; zeros(1, 2)];
    D_expected = [0, 0, 0;
                  0, 5, 6];

    __blkdiag_assert_close__(sys_static.A, A_expected, "Test Case 4: numeric static gain A matrix passed");
    __blkdiag_assert_close__(sys_static.B, B_expected, "Test Case 4: numeric static gain B matrix passed");
    __blkdiag_assert_close__(sys_static.C, C_expected, "Test Case 4: numeric static gain C matrix passed");
    __blkdiag_assert_close__(sys_static.D, D_expected, "Test Case 4: numeric static gain D matrix passed");

    // Test Case 5: discrete-time systems with identical sampling domain
    Ad1 = [0.5];
    Bd1 = [1];
    Cd1 = [2];
    Dd1 = [0];
    dsys1 = syslin("d", Ad1, Bd1, Cd1, Dd1);

    Ad2 = [0.25];
    Bd2 = [3];
    Cd2 = [4];
    Dd2 = [1];
    dsys2 = syslin("d", Ad2, Bd2, Cd2, Dd2);

    dsys = blkdiag(dsys1, dsys2);

    A_expected = [Ad1, 0;
                  0, Ad2];
    B_expected = [Bd1, 0;
                  0, Bd2];
    C_expected = [Cd1, 0;
                  0, Cd2];
    D_expected = [Dd1, 0;
                  0, Dd2];

    __blkdiag_assert_close__(dsys.A, A_expected, "Test Case 5: discrete-time A matrix passed");
    __blkdiag_assert_close__(dsys.B, B_expected, "Test Case 5: discrete-time B matrix passed");
    __blkdiag_assert_close__(dsys.C, C_expected, "Test Case 5: discrete-time C matrix passed");
    __blkdiag_assert_close__(dsys.D, D_expected, "Test Case 5: discrete-time D matrix passed");

    // Test Case 6: mismatched time domains must be rejected
    err_detected = %f;

    try
        temp = blkdiag(sys1, dsys1);
    catch
        err_detected = %t;
    end

    if err_detected then
        disp("Test Case 6: mismatched sampling time detected successfully");
    else
        error("Test Case 6 failed: mismatched sampling time was not detected");
    end

    // Test Case 7: invalid argument must be rejected
    err_detected = %f;

    try
        temp = blkdiag(sys1, "wrong");
    catch
        err_detected = %t;
    end

    if err_detected then
        disp("Test Case 7: invalid argument detected successfully");
    else
        error("Test Case 7 failed: invalid argument was not detected");
    end

    disp("All blkdiag test cases completed.");

endfunction


function __blkdiag_assert_close__(actual, expected, message)

    if or(size(actual) <> size(expected)) then
        error(message + " - size mismatch");
    end

    if norm(actual(:) - expected(:)) > 1.d-8 then
        error(message + " - value mismatch");
    else
        disp(message);
    end

endfunction
