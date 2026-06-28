// Copyright (C) 2026
// Scilab translation for FOSSEE Control Systems Toolbox
//
// Calling Sequence:
//     H = freqresp(sys, w)
//
// Parameters:
//     sys : LTI system created using syslin() or a rational transfer function.
//     w   : Real vector of angular frequencies in rad/s.
//     H   : Frequency-response array of size [outputs, inputs, length(w)].
//
// Description:
//     Evaluate the frequency response of an LTI system at the given
//     angular frequencies. For a system with p outputs and m inputs,
//     H(:, :, k) is the response at frequency w(k).
//
// Octave source structure:
//     function H = freqresp(sys, w)
//         if (nargin != 2)
//             print_usage();
//         endif
//         if (! is_real_vector(w))
//             error("freqresp: second argument w must be a real-valued vector of frequencies");
//         endif
//         H = __freqresp__(sys, w);
//     endfunction
//
// Dependency:
//     __freqresp__.sci

function H = freqresp(sys, w)

    rhs = argn(2);

    if rhs <> 2 then
        error("freqresp: wrong number of input arguments");
    end

    if ~__freqresp_is_real_vector__(w) then
        error("freqresp: second argument w must be a real-valued vector of frequencies");
    end

    H = __freqresp__(sys, w);

endfunction


function flag = __freqresp_is_real_vector__(w)

    flag = %f;

    if typeof(w) <> "constant" then
        return;
    end

    if ~isreal(w) then
        return;
    end

    if isempty(w) then
        return;
    end

    sz = size(w);

    if length(sz) > 2 then
        return;
    end

    if sz(1) == 1 | sz(2) == 1 then
        flag = %t;
    end

endfunction


// ------------------------------------------------------------
// Unit test function
// Run manually using:
// exec("__freqresp__.sci", -1);
// exec("freqresp.sci", -1);
// freqresp_test();
//
// Note:
// The official Octave freqresp wrapper does not contain a %!assert
// block in the current source. These tests are written in Octave-style
// expected-output form using the same response definition:
//     H(:, :, k) = C * ((s(k) * I - A) \ B) + D
// with s = i*w for continuous-time systems and z = exp(i*w*T) for
// discrete-time systems.
// ------------------------------------------------------------

function freqresp_test()

    disp("Running freqresp test cases...");

    // Test Case 1: continuous-time SISO state-space system
    A = [0, 1; -2, -3];
    B = [0; 1];
    C = [1, 0];
    D = 0;
    sys = syslin("c", A, B, C, D);
    w = [0, 1, 2];

    H = freqresp(sys, w);

    H_expected = zeros(1, 1, 3);
    H_expected(:, :, 1) = 0.5;
    H_expected(:, :, 2) = 1 / (1 + 3 * %i);
    H_expected(:, :, 3) = 1 / (-2 + 6 * %i);

    __freqresp_assert_close__(H, H_expected, "Test Case 1: continuous-time SISO response passed");


    // Test Case 2: continuous-time MIMO state-space system
    A = [0, 1, 0; 0, 0, 1; -1, -3, -3];
    B = [0, 0; 0, 1; 1, 1];
    C = [1, 0, 0; 0, 1, 1];
    D = [2, 0; 0, 0];
    sys = syslin("c", A, B, C, D);
    w = [0, 2];

    H = freqresp(sys, w);

    H0_expected = C * ((0 * %i * eye(3, 3) - A) \ B) + D;
    H2_expected = C * ((2 * %i * eye(3, 3) - A) \ B) + D;

    __freqresp_assert_close__(H(:, :, 1), H0_expected, "Test Case 2: MIMO response at w = 0 passed");
    __freqresp_assert_close__(H(:, :, 2), H2_expected, "Test Case 2: MIMO response at w = 2 passed");


    // Test Case 3: discrete-time system with implicit unit sample time
    A = [0.5];
    B = [1];
    C = [2];
    D = [0];
    sys = syslin("d", A, B, C, D);
    w = [0, %pi/2];

    H = freqresp(sys, w);

    z1 = exp(%i * w(1));
    z2 = exp(%i * w(2));

    H_expected = zeros(1, 1, 2);
    H_expected(:, :, 1) = C * ((z1 * eye(1, 1) - A) \ B) + D;
    H_expected(:, :, 2) = C * ((z2 * eye(1, 1) - A) \ B) + D;

    __freqresp_assert_close__(H, H_expected, "Test Case 3: discrete-time response passed");


    // Test Case 4: column-vector frequency input
    H_col = freqresp(sys, [0; %pi/2]);
    __freqresp_assert_close__(H_col, H_expected, "Test Case 4: column frequency vector passed");


    // Test Case 5: scalar frequency input
    H_scalar = freqresp(sys, 0);
    H_scalar_expected = zeros(1, 1, 1);
    H_scalar_expected(:, :, 1) = C * ((eye(1, 1) - A) \ B) + D;
    __freqresp_assert_close__(H_scalar, H_scalar_expected, "Test Case 5: scalar frequency input passed");


    // Test Case 6: invalid complex frequency vector
    err_detected = %f;

    try
        temp = freqresp(sys, [1 + %i, 2]);
    catch
        err_detected = %t;
    end

    if err_detected then
        disp("Test Case 6: complex frequency vector detected successfully");
    else
        error("Test Case 6 failed: complex frequency vector was not detected");
    end


    // Test Case 7: wrong number of arguments
    err_detected = %f;

    try
        temp = freqresp(sys);
    catch
        err_detected = %t;
    end

    if err_detected then
        disp("Test Case 7: wrong number of arguments detected successfully");
    else
        error("Test Case 7 failed: wrong number of arguments was not detected");
    end

    disp("All freqresp test cases completed.");

endfunction


function __freqresp_assert_close__(actual, expected, message)

    if or(size(actual) <> size(expected)) then
        error(message + " - size mismatch");
    end

    if norm(actual(:) - expected(:)) > 1.d-8 then
        error(message + " - value mismatch");
    else
        disp(message);
    end

endfunction
