// freqresp.sci
// Matches GNU Octave freqresp behavior (including empty w)

function H = freqresp(sys, w)

    if argn(2) <> 2 then
        error("freqresp: exactly two input arguments required (sys, w)");
    end

    // Allow empty w (as in Octave when used internally)
    if isempty(w) then
        // For empty w, return empty 3D array with correct dimensions
        [ny, nu] = size(sys);
        H = zeros(ny, nu, 0);
        return;
    end

    if ~isreal(w) | min(size(w)) <> 1 then
        error("freqresp: second argument ''w'' must be a real-valued vector of frequencies");
    end
    w = real(w(:)');

    H = __freqresp__(sys, w);

endfunction
// ====================== Test Cases ======================

disp("=== freqresp Test Cases ===")

// Test Case 1: SISO continuous
s = poly(0,'s');
G = syslin('c', 1/(s+1));
w = [0, 1, 10];
H = freqresp(G, w);
disp("Test 1 - SISO:", size(H));

// Test Case 2: Empty frequency vector (new)
Hempty = freqresp(G, []);
disp("Test 2 - Empty w:", size(Hempty));

// Test Case 3: MIMO
G3 = syslin('c', [1; s]/(s+1));
H3 = freqresp(G3, [0 1]);
disp("Test 3 - MIMO:", size(H3));

// Test Case 4: Discrete
G4 = syslin(0.1, 1/(1-0.9*%z^-1));
H4 = freqresp(G4, [0 %pi]);
disp("Test 4 - Discrete:", size(H4));

// Test Case 5: Scalar frequency
H5 = freqresp(G, 5);
disp("Test 5 - Scalar w:", size(H5));
