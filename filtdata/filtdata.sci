// Copyright (C) 2009-2016   Lukas F. Reichlin
// Scilab translation and integration: Pavan Kumar
//
// This file is a Scilab source-structure translation of GNU Octave
// Control package filtdata.m.
//
// Calling Sequence:
//     [num, den, tsam] = filtdata(sys)
//     [num, den, tsam] = filtdata(sys, "vector")
//
// Parameters:
//     sys   : Discrete-time LTI model or real-valued static-gain matrix.
//     rtype : Optional return type. "vector" returns vectors for SISO systems.
//     num   : Numerator coefficients in DSP format.
//     den   : Denominator coefficients in DSP format.
//     tsam  : Sampling time.
//
// Direct dependencies:
//     tfdata.sci
//     isdt.sci
//     issiso.sci

function [num, den, tsam] = filtdata(sys, rtype)

    [lhs, rhs] = argn(0);

    if rhs > 2 then
        error("filtdata: wrong number of input arguments");
    end

    if rhs < 2 then
        rtype = "cell";
    end

    if ~__filtdata_is_lti__(sys) then
        if ~__filtdata_is_real_matrix__(sys) then
            error("filtdata: has to be called with an LTI object or with a real matrix static gain");
        else
            [num, den, tsam] = __filtdata_static_gain_data__(sys);
        end
    else
        if ~isdt(sys) then
            error("lti: filtdata: require discrete-time system");
        end

        [num, den, tsam] = tfdata(sys);
        [num, den] = __filtdata_force_cell__(num, den);
    end

    [num, den] = __filtdata_equalize_cells__(num, den);

    if __filtdata_starts_with__(rtype, "v") then
        if __filtdata_is_real_matrix__(sys) then
            siso_flag = (size(sys, 1) == 1 & size(sys, 2) == 1);
        else
            siso_flag = issiso(sys);
        end

        if siso_flag then
            num = num{1, 1};
            den = den{1, 1};
        end
    end

endfunction


function flag = __filtdata_is_lti__(sys)

    sys_type = typeof(sys);
    flag = (sys_type == "rational") | (sys_type == "state-space");

endfunction


function flag = __filtdata_is_real_matrix__(x)

    flag = %f;

    if typeof(x) <> "constant" then
        return;
    end

    if ~isreal(x) then
        return;
    end

    x_size = size(x);

    if length(x_size) <= 2 then
        flag = %t;
    end

endfunction


function [num, den, tsam] = __filtdata_static_gain_data__(gain_matrix)

    [p, m] = size(gain_matrix);

    num = cell(p, m);
    den = cell(p, m);

    for i = 1:p
        for j = 1:m
            num{i, j} = gain_matrix(i, j);
            den{i, j} = 1;
        end
    end

    // Octave treats numeric static gain as discrete-time with unspecified sample time.
    tsam = -1;

endfunction


function [num, den] = __filtdata_force_cell__(num, den)

    if iscell(num) then
        return;
    end

    num_vector = matrix(num, 1, -1);
    den_vector = matrix(den, 1, -1);

    num_cell = cell(1, 1);
    den_cell = cell(1, 1);

    num_cell{1, 1} = num_vector;
    den_cell{1, 1} = den_vector;

    num = num_cell;
    den = den_cell;

endfunction


function [num, den] = __filtdata_equalize_cells__(num, den)

    dims = size(num);

    if length(dims) == 2 then
        for i = 1:dims(1)
            for j = 1:dims(2)
                nvec = matrix(num{i, j}, 1, -1);
                dvec = matrix(den{i, j}, 1, -1);
                lmax = max(length(nvec), length(dvec));
                num{i, j} = __filtdata_prepad__(nvec, lmax);
                den{i, j} = __filtdata_prepad__(dvec, lmax);
            end
        end
    elseif length(dims) == 3 then
        for i = 1:dims(1)
            for j = 1:dims(2)
                for k = 1:dims(3)
                    nvec = matrix(num{i, j, k}, 1, -1);
                    dvec = matrix(den{i, j, k}, 1, -1);
                    lmax = max(length(nvec), length(dvec));
                    num{i, j, k} = __filtdata_prepad__(nvec, lmax);
                    den{i, j, k} = __filtdata_prepad__(dvec, lmax);
                end
            end
        end
    else
        error("filtdata: unsupported transfer function data dimensions");
    end

endfunction


function y = __filtdata_prepad__(x, target_length)

    x = matrix(x, 1, -1);
    pad_length = target_length - length(x);

    if pad_length > 0 then
        y = [zeros(1, pad_length), x];
    else
        y = x;
    end

endfunction


function flag = __filtdata_starts_with__(str_value, prefix)

    flag = %f;

    if typeof(str_value) <> "string" then
        return;
    end

    str_value = convstr(str_value, "l");
    prefix = convstr(prefix, "l");

    if length(str_value) < length(prefix) then
        return;
    end

    flag = (part(str_value, 1:length(prefix)) == prefix);

endfunction


function __filtdata_assert_close__(actual, expected, message)

    actual = matrix(actual, 1, -1);
    expected = matrix(expected, 1, -1);

    if or(size(actual) <> size(expected)) then
        error(message + " - size mismatch");
    end

    if norm(actual - expected) > 1.d-8 then
        error(message + " - value mismatch");
    else
        disp(message);
    end

endfunction


function filtdata_test()

    disp("Running filtdata test cases...");

    // Test Case 1: SISO discrete-time transfer function, cell output
    z = poly(0, "z");
    sys1 = syslin("d", (z + 2) / (z^2 + 3*z + 4));

    [num, den, tsam] = filtdata(sys1);

    __filtdata_assert_close__(num{1, 1}, [0, 2, 1], "Test Case 1: SISO numerator cell output passed");
    __filtdata_assert_close__(den{1, 1}, [4, 3, 1], "Test Case 1: SISO denominator cell output passed");

    if tsam == 1 | tsam == "d" then
        disp("Test Case 1: sampling time output passed");
    else
        error("Test Case 1: sampling time output failed");
    end

    // Test Case 2: SISO vector output mode
    [numv, denv, tsamv] = filtdata(sys1, "vector");

    __filtdata_assert_close__(numv, [0, 2, 1], "Test Case 2: SISO vector numerator output passed");
    __filtdata_assert_close__(denv, [4, 3, 1], "Test Case 2: SISO vector denominator output passed");

    // Test Case 3: Numeric static-gain matrix
    K = [2, 3;
         4, 5];

    [numk, denk, tsamk] = filtdata(K);

    __filtdata_assert_close__(numk{1, 1}, [2], "Test Case 3: static gain numerator (1,1) passed");
    __filtdata_assert_close__(numk{1, 2}, [3], "Test Case 3: static gain numerator (1,2) passed");
    __filtdata_assert_close__(numk{2, 1}, [4], "Test Case 3: static gain numerator (2,1) passed");
    __filtdata_assert_close__(numk{2, 2}, [5], "Test Case 3: static gain numerator (2,2) passed");
    __filtdata_assert_close__(denk{1, 1}, [1], "Test Case 3: static gain denominator passed");

    if tsamk == -1 then
        disp("Test Case 3: static gain sampling time passed");
    else
        error("Test Case 3: static gain sampling time failed");
    end

    // Test Case 4: Continuous-time system should be rejected
    s = poly(0, "s");
    sysc = syslin("c", (s + 1) / (s^2 + 2*s + 3));

    err_detected = %f;

    try
        [numc, denc, tsamc] = filtdata(sysc);
    catch
        err_detected = %t;
    end

    if err_detected then
        disp("Test Case 4: continuous-time system rejected successfully");
    else
        error("Test Case 4 failed: continuous-time system was not rejected");
    end

    // Test Case 5: Wrong number of input arguments
    err_detected = %f;

    try
        [numw, denw, tsamw] = filtdata(sys1, "vector", "extra");
    catch
        err_detected = %t;
    end

    if err_detected then
        disp("Test Case 5: wrong number of input arguments detected successfully");
    else
        error("Test Case 5 failed: wrong number of input arguments was not detected");
    end

    // Test Case 6: Invalid complex static gain
    err_detected = %f;

    try
        [numi, deni, tsami] = filtdata([1 + %i]);
    catch
        err_detected = %t;
    end

    if err_detected then
        disp("Test Case 6: complex static gain rejected successfully");
    else
        error("Test Case 6 failed: complex static gain was not rejected");
    end

    disp("All filtdata test cases completed.");

endfunction
