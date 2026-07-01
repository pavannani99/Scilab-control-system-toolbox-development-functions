function [first_out, second_out, third_out, fourth_out] = ss2ss(first_in, second_in, third_in, fourth_in, fifth_in)

    rhs = argn(2);
    lhs = argn(1);

    if rhs <> 2 & rhs <> 5 then
        error("ss2ss: Wrong number of input arguments.");
    end

    select rhs
    case 2 then
        [A, B, C, D] = ssdata(first_in);
        T = inv(second_in);

    case 5 then
        A = first_in;
        B = second_in;
        C = third_in;
        D = fourth_in;
        T = inv(fifth_in);
    end

    A_T = inv(T) * A * T;
    B_T = inv(T) * B;
    C_T = C * T;
    D_T = D;

    select rhs
    case 2 then
        if lhs > 1 then
            error("Too many output arguments");
        end
        first_out = syslin("c", A_T, B_T, C_T, D_T);

    case 5 then
        if lhs > 4 then
            error("Too many output arguments");
        end
        first_out = A_T;
        second_out = B_T;
        third_out = C_T;
        fourth_out = D_T;
    end

endfunction


A = [1 2 3;
     4 5 6;
     7 8 9];

B = [1;
     2;
     3];

C = [-1 0 1];

D = 0;

[T, E] = spec(A);

sys = syslin("c", A, B, C, D);

//test_cases
disp("TEST CASE 1");
sys_t = ss2ss(sys, T);
disp(sys_t.A);
disp(sys_t.B);
disp(sys_t.C);
disp(sys_t.D);


disp("TEST CASE 2");
[A_t, B_t, C_t, D_t] = ss2ss(A, B, C, D, T);
disp(A_t);
disp(B_t);
disp(C_t);
disp(D_t);


disp("TEST CASE 3");
sys_original = ss2ss(sys_t, inv(T));
disp(sys_original.A);
disp(sys_original.B);
disp(sys_original.C);
disp(sys_original.D);


disp("TEST CASE 4");
I = eye(A);
sys_identity = ss2ss(sys, I);
disp(sys_identity.A);
disp(sys_identity.B);
disp(sys_identity.C);
disp(sys_identity.D);


disp("TEST CASE 5");
sys_t = ss2ss(sys, T);
[A_t, B_t, C_t, D_t] = ss2ss(A, B, C, D, T);

disp(norm(sys_t.A - A_t));
disp(norm(sys_t.B - B_t));
disp(norm(sys_t.C - C_t));
disp(norm(sys_t.D - D_t));
