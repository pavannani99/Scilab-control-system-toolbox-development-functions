// Copyright (C) 2017 Fabian Alexander Wilms <f.alexander.wilms@gmail.com>
// Scilab translation for Control Toolbox style submission.
//
// Applies the similarity transformation T to a state-space model.
//
// Calling Sequence:
//     sys_t = ss2ss(sys, T)
//     [A_t, B_t, C_t, D_t] = ss2ss(A, B, C, D, T)
//
// For x_bar = T*x, the transformed system is:
//     A_t = T*A*inv(T)
//     B_t = T*B
//     C_t = C*inv(T)
//     D_t = D
//
// Note: The implementation follows the Octave source structure where
// T is internally inverted before applying the transformation.

function [first_out, second_out, third_out, fourth_out] = ss2ss(first_in, second_in, third_in, fourth_in, fifth_in)
    [lhs, rhs] = argn(0);

    first_out = [];
    second_out = [];
    third_out = [];
    fourth_out = [];

    if rhs <> 2 & rhs <> 5 then
        error("ss2ss: invalid number of input arguments");
    end

    select rhs
    case 2 then
        [A, B, C, D] = ssdata(first_in);
        if lhs > 1 then
            error("Too many output arguments");
        end
        if typeof(first_in) == "state-space" then
            dom = first_in.dt;
        else
            dom = "c";
        end
        T = inv(second_in);

    case 5 then
        A = first_in;
        B = second_in;
        C = third_in;
        D = fourth_in;
        if lhs > 4 then
            error("Too many output arguments");
        end
        T = inv(fifth_in);
    end

    A_T = inv(T) * A * T;
    B_T = inv(T) * B;
    C_T = C * T;
    D_T = D;

    select rhs
    case 2 then
        first_out = syslin(dom, A_T, B_T, C_T, D_T);

    case 5 then
        first_out = A_T;
        second_out = B_T;
        third_out = C_T;
        fourth_out = D_T;
    end
endfunction

function ss2ss_test()
    // Test cases are kept in this same file to avoid a separate .sce file.

    if exists("ssdata") == 0 then
        error("ss2ss_test: load ssdata.sci before running the test function");
    end

    tol = 1d-10;

    A = [1 2 3; 4 5 6; 7 8 9];
    B = [1; 2; 3];
    C = [-1 0 1];
    D = 0;
    T = [1 0 0; 1 1 0; 0 1 1];

    A_expected = T * A * inv(T);
    B_expected = T * B;
    C_expected = C * inv(T);
    D_expected = D;

    [A_t, B_t, C_t, D_t] = ss2ss(A, B, C, D, T);
    __ss2ss_assert_close__(A_t, A_expected, tol, "Matrix-input A transformation");
    __ss2ss_assert_close__(B_t, B_expected, tol, "Matrix-input B transformation");
    __ss2ss_assert_close__(C_t, C_expected, tol, "Matrix-input C transformation");
    __ss2ss_assert_close__(D_t, D_expected, tol, "Matrix-input D transformation");
    disp("Test 1 passed: matrix input transformation");

    original_system = syslin("c", A, B, C, D);
    transformed_system = ss2ss(original_system, T);
    [A_sys, B_sys, C_sys, D_sys] = ssdata(transformed_system);
    __ss2ss_assert_close__(A_sys, A_expected, tol, "System-input A transformation");
    __ss2ss_assert_close__(B_sys, B_expected, tol, "System-input B transformation");
    __ss2ss_assert_close__(C_sys, C_expected, tol, "System-input C transformation");
    __ss2ss_assert_close__(D_sys, D_expected, tol, "System-input D transformation");
    disp("Test 2 passed: state-space system input transformation");

    retransformed_system = ss2ss(transformed_system, inv(T));
    [A_back, B_back, C_back, D_back] = ssdata(retransformed_system);
    __ss2ss_assert_close__(A_back, A, tol, "Retransformed A matrix");
    __ss2ss_assert_close__(B_back, B, tol, "Retransformed B matrix");
    __ss2ss_assert_close__(C_back, C, tol, "Retransformed C matrix");
    __ss2ss_assert_close__(D_back, D, tol, "Retransformed D matrix");
    disp("Test 3 passed: inverse transformation returns original system");

    err_flag = %f;
    try
        [x1, x2] = ss2ss(original_system, T);
    catch
        err_flag = %t;
    end
    if err_flag == %f then
        error("Test 4 failed: system-input form should allow only one output argument");
    end
    disp("Test 4 passed: too many output arguments detected");

    err_flag = %f;
    try
        ss2ss(A, B);
    catch
        err_flag = %t;
    end
    if err_flag == %f then
        error("Test 5 failed: invalid two-input matrix call was not detected");
    end
    disp("Test 5 passed: invalid two-input matrix call detected");

    disp("All ss2ss tests passed successfully");
endfunction

function __ss2ss_assert_close__(actual, expected, tol, msg)
    if norm(actual - expected) > tol then
        error(msg + " failed");
    end
endfunction
