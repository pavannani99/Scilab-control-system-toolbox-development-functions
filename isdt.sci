// Determine whether LTI model is a discrete-time system.
//
// Calling Sequence:
//     bool = isdt(sys)
//
// Parameters:
//     sys  - LTI system (syslin object)
//     bool - %t if sys is discrete-time, %f otherwise

funcprot(0);

function bool = isdt(sys)
    [lhs, rhs] = argn(0);

    if rhs <> 1 then
        error("isdt: wrong number of input arguments");
    end

    if typeof(sys) <> "state-space" & typeof(sys) <> "rational" then
        error("isdt: input argument must be an LTI system");
    end

    bool = (sys.dt <> "c");
endfunction


// -------------------------------------------------------------------------
// TEST CASES
// -------------------------------------------------------------------------

// Test Case 1: discrete-time state-space system with specified sample time
A1 = [-1, 0; 0, -2];
B1 = [1; 1];
C1 = [1, 0];
D1 = [0];
sys1 = syslin(0.1, A1, B1, C1, D1);

if isdt(sys1) == %t then
    disp("Test Case 1: Discrete-time state-space detected correctly");
else
    error("Test Case 1 failed");
end

// Test Case 2: continuous-time state-space system
sys2 = syslin("c", A1, B1, C1, D1);

if isdt(sys2) == %f then
    disp("Test Case 2: Continuous-time state-space correctly rejected");
else
    error("Test Case 2 failed");
end

// Test Case 3: discrete-time transfer function with unspecified sample time
z3 = poly(0, "z");
sys3 = syslin("d", (z3 + 1), (z3 + 2));

if isdt(sys3) == %t then
    disp("Test Case 3: Discrete-time transfer function detected correctly");
else
    error("Test Case 3 failed");
end

// Test Case 4: continuous-time transfer function
s4 = poly(0, "s");
sys4 = syslin("c", (s4 + 1), (s4 + 2));

if isdt(sys4) == %f then
    disp("Test Case 4: Continuous-time transfer function correctly rejected");
else
    error("Test Case 4 failed");
end

// Test Case 5: invalid input
err_flag = execstr("isdt([1, 2, 3]);", "errcatch");

if err_flag <> 0 then
    disp("Test Case 5: Invalid argument detected successfully");
else
    error("Test Case 5 failed");
end

// Test Case 6: wrong number of input arguments
err_flag = execstr("isdt();", "errcatch");

if err_flag <> 0 then
    disp("Test Case 6: Wrong number of input arguments detected successfully");
else
    error("Test Case 6 failed");
end
