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


