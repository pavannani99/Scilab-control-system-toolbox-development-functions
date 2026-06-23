// Determine whether LTI model is a continuous-time system.
//
// Calling Sequence:
//     bool = isct(sys)
//
// Parameters:
//     sys  - LTI system (syslin object)
//     bool - %t if sys is continuous-time, %f otherwise

funcprot(0);

function bool = isct(sys)
    [lhs, rhs] = argn(0);

    if rhs <> 1 then
        error("isct: wrong number of input arguments");
    end

    if typeof(sys) <> "state-space" & typeof(sys) <> "rational" then
        error("isct: input argument must be an LTI system");
    end

    bool = (sys.dt == "c");
endfunction


// -------------------------------------------------------------------------
// TEST CASES
// -------------------------------------------------------------------------

// Test Case 1: continuous-time state-space system
A1 = [-1, 0; 0, -2];
B1 = [1; 1];
C1 = [1, 0];
D1 = [0];
sys1 = syslin("c", A1, B1, C1, D1);

if isct(sys1) == %t then
    disp("Test Case 1: Continuous-time state-space detected correctly");
else
    error("Test Case 1 failed");
end

// Test Case 2: discrete-time state-space system
sys2 = syslin(0.1, A1, B1, C1, D1);

if isct(sys2) == %f then
    disp("Test Case 2: Discrete-time state-space correctly rejected");
else
    error("Test Case 2 failed");
end

// Test Case 3: continuous-time transfer function
s3 = poly(0, "s");
sys3 = syslin("c", (s3 + 1), (s3 + 2));

if isct(sys3) == %t then
    disp("Test Case 3: Continuous-time transfer function detected correctly");
else
    error("Test Case 3 failed");
end

// Test Case 4: discrete-time transfer function with unspecified sample time
z4 = poly(0, "z");
sys4 = syslin("d", (z4 + 1), (z4 + 2));

if isct(sys4) == %f then
    disp("Test Case 4: Discrete-time transfer function correctly rejected");
else
    error("Test Case 4 failed");
end

// Test Case 5: invalid input
err_flag = execstr("isct([1, 2, 3]);", "errcatch");

if err_flag <> 0 then
    disp("Test Case 5: Invalid argument detected successfully");
else
    error("Test Case 5 failed");
end

// Test Case 6: wrong number of input arguments
err_flag = execstr("isct();", "errcatch");

if err_flag <> 0 then
    disp("Test Case 6: Wrong number of input arguments detected successfully");
else
    error("Test Case 6 failed");
end
