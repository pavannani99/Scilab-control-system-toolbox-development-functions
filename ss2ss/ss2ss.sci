function [first_out, second_out, third_out, fourth_out] = ss2ss(first_in, second_in, third_in, fourth_in, fifth_in)
    lhs = argn(1);
    rhs = argn(2);

    if rhs <> 2 & rhs <> 5 then
        error("ss2ss: wrong number of input arguments");
    end

    // Dispatcher logic
    if rhs == 2 then
        sys = first_in; T = second_in;
        [A, B, C, D, E, stname, scaled] = __sys_data__(sys);
        [A, B, C, D, E] = __dss2ss__(A, B, C, D, E);
        
        invT = inv(T);
        A_t = invT * A * T;
        B_t = invT * B;
        C_t = C * T;
        D_t = D;
        
        first_out = syslin(sys.dt, A_t, B_t, C_t, D_t);
    else
        A = first_in; B = second_in; C = third_in; D = fourth_in;
        invT = inv(fifth_in);
        A_t = invT * A * fifth_in;
        B_t = invT * B;
        C_t = C * fifth_in;
        D_t = D;
        
        first_out = A_t; second_out = B_t; third_out = C_t; fourth_out = D_t;
    end
endfunction

// --- Integrated Test Cases ---
if argn(2) == 0 then
    disp("Running ss2ss tests...");
    
    // Setup
    A = [1 2 3; 4 5 6; 7 8 9]; B = [1; 2; 3]; C = [-1 0 1]; D = 0;
    T = [1 0 0; 0 1 0; 1 1 1];
    
    // Case 1: Matrix Input
    [A_t, B_t, C_t, D_t] = ss2ss(A, B, C, D, T);
    if norm(A_t - (inv(T)*A*T)) < 1e-10 then disp("Test 1 Passed"); end
    
    // Case 2: System Input
    sys = syslin('c', A, B, C, D);
    sys_t = ss2ss(sys, T);
    if norm(sys_t.A - (inv(T)*A*T)) < 1e-10 then disp("Test 2 Passed"); end
    
    // Case 3: Inverse Transformation
    sys_back = ss2ss(sys_t, inv(T));
    if norm(sys_back.A - A) < 1e-10 then disp("Test 3 Passed"); end
    
    disp("All tests completed.");
end
