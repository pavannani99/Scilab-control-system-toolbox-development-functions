/*
 * freqresp.sci
 * Scilab translation of GNU Octave Control package freqresp function.
 *
 * Author: Pavan Kumar
 * Year: 2026
 */

/*
Description:
Evaluates the frequency response of a continuous-time state-space system
at the given frequency values.

Calling Sequence:
H = freqresp(sys, w)

Dependencies:
__freqresp__.sci
*/

function H = freqresp(sys, w)

    if argn(2) <> 2 then
        error("freqresp: wrong number of input arguments");
    end

    if type(w) <> 1 | ~isreal(w) | ~(size(w, 1) == 1 | size(w, 2) == 1) then
        error("freqresp: second argument ''w'' must be a real-valued vector of frequencies");
    end

    H = __freqresp__(sys, w);

endfunction

// -----------------------------------------------------------------------------
// Test cases
// Execute the dependency before this file:
// exec("__freqresp__.sci", -1);
// exec("freqresp.sci", -1);
// -----------------------------------------------------------------------------

tol = 1d-10;

// TEST CASE 1: SISO first-order system

A = -1;
B = 1;
C = 1;
D = 0;
w = [0 1 2];

sys1 = syslin("c", A, B, C, D);
H = freqresp(sys1, w);

H_expected = zeros(1, 1, length(w));
for k = 1:length(w)
    H_expected(:, :, k) = 1 / (1 + %i * w(k));
end

if norm(H - H_expected) < tol then
    disp("Test Case 1: SISO frequency response passed");
else
    disp("Test Case 1: SISO frequency response failed");
end

disp("Test Case 1: Frequency response values");
for k = 1:length(w)
    disp("w = " + string(w(k)));
    disp(H(:, :, k));
end

// TEST CASE 2: System with direct feedthrough term

A = -2;
B = 1;
C = 3;
D = 2;
w = 0;

sys2 = syslin("c", A, B, C, D);
H = freqresp(sys2, w);
H_expected = 3 / 2 + 2;

if norm(H(:, :, 1) - H_expected) < tol then
    disp("Test Case 2: Direct feedthrough response passed");
else
    disp("Test Case 2: Direct feedthrough response failed");
end

disp("Test Case 2: Frequency response value");
disp(H(:, :, 1));

// TEST CASE 3: MIMO system response at zero frequency

A = -1;
B = [1 2];
C = [3; 4];
D = [0 0; 0 0];
w = 0;

sys3 = syslin("c", A, B, C, D);
H = freqresp(sys3, w);
H_expected = [3 6; 4 8];

if norm(H(:, :, 1) - H_expected) < tol then
    disp("Test Case 3: MIMO frequency response passed");
else
    disp("Test Case 3: MIMO frequency response failed");
end

disp("Test Case 3: Frequency response matrix");
disp(H(:, :, 1));

// TEST CASE 4: Column vector frequency input

A = -1;
B = 1;
C = 1;
D = 0;
w = [0; 1; 2];

sys4 = syslin("c", A, B, C, D);
H = freqresp(sys4, w);

if size(H, 3) == length(w) then
    disp("Test Case 4: Column frequency vector passed");
else
    disp("Test Case 4: Column frequency vector failed");
end

disp("Test Case 4: Size of output array H");
disp(size(H));

// TEST CASE 5: Invalid complex frequency vector

try
    freqresp(sys4, [1 %i]);
catch
    disp("Test Case 5: Invalid frequency input detected successfully");
end

// TEST CASE 6: Wrong number of input arguments

try
    freqresp(sys4);
catch
    disp("Test Case 6: Wrong number of input arguments detected successfully");
end
