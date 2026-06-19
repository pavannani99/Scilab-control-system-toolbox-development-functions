/* 2026 Author: Pavan Kumar */
/*
ss2ss.sci
Applies a similarity transformation to a state-space model.

Description:
    Transforms the state coordinates of a state-space system using the
    transformation matrix T. This Scilab implementation follows the GNU
    Octave ss2ss source structure and supports both system input and
    direct matrix input forms.

Calling Sequence:
    sys_t = ss2ss(sys, T)
    [A_t, B_t, C_t, D_t] = ss2ss(A, B, C, D, T)

Parameters:
    sys   - State-space system created using syslin
    A     - State matrix
    B     - Input matrix
    C     - Output matrix
    D     - Feedthrough matrix
    T     - State transformation matrix
    sys_t - Transformed state-space system
    A_t   - Transformed state matrix
    B_t   - Transformed input matrix
    C_t   - Transformed output matrix
    D_t   - Transformed feedthrough matrix

Dependencies:
    ssdata.sci
*/

function [first_out, second_out, third_out, fourth_out] = ss2ss(first_in, second_in, third_in, fourth_in, fifth_in)
    lhs = argn(1);
    rhs = argn(2);

    if rhs <> 2 & rhs <> 5 then
        error("ss2ss: wrong number of input arguments");
    end

    select rhs
    case 2 then
        if lhs > 1 then
            error("ss2ss: too many output arguments");
        end

        [A, B, C, D] = ssdata(first_in);
        // Attention: T as defined by Matlab is the inverse of T as defined by
        // Goodwin, Graebe, Salgado.
        T = inv(second_in);

    case 5 then
        if lhs > 4 then
            error("ss2ss: too many output arguments");
        end

        A = first_in;
        B = second_in;
        C = third_in;
        D = fourth_in;
        // See note above.
        T = inv(fifth_in);
    end

    A_t = inv(T) * A * T;
    B_t = inv(T) * B;
    C_t = C * T;
    D_t = D;

    select rhs
    case 2 then
        first_out = syslin("c", A_t, B_t, C_t, D_t);

    case 5 then
        first_out = A_t;
        second_out = B_t;
        third_out = C_t;
        fourth_out = D_t;
    end
endfunction

//---------------------------------------------------------------------------------------------------------------------------------------//

// test case 1: direct matrix input transformation
A = [1, 2, 3; 4, 5, 6; 7, 8, 9];
B = [1; 2; 3];
C = [-1, 0, 1];
D = [0];
T = [1, 0, 0; 0, 1, 0; 1, 1, 1];

[A_t, B_t, C_t, D_t] = ss2ss(A, B, C, D, T);
A_expected = T * A * inv(T);
B_expected = T * B;
C_expected = C * inv(T);
D_expected = D;

if norm(A_t - A_expected) < 1D-10 & norm(B_t - B_expected) < 1D-10 & norm(C_t - C_expected) < 1D-10 & norm(D_t - D_expected) < 1D-10 then
    disp("test case 1: ss2ss matrix input transformation passed");
else
    error("test case 1 failed");
end

disp("A_t:");
disp(A_t);
disp("B_t:");
disp(B_t);
disp("C_t:");
disp(C_t);
disp("D_t:");
disp(D_t);
disp("----------------------------------------------------------------------------------------------------------------------------------");

// test case 2: state-space system input transformation
sys = syslin("c", A, B, C, D);
sys_t = ss2ss(sys, T);

if norm(sys_t.A - A_expected) < 1D-10 & norm(sys_t.B - B_expected) < 1D-10 & norm(sys_t.C - C_expected) < 1D-10 & norm(sys_t.D - D_expected) < 1D-10 then
    disp("test case 2: ss2ss system input transformation passed");
else
    error("test case 2 failed");
end

disp("A_t:");
disp(sys_t.A);
disp("B_t:");
disp(sys_t.B);
disp("C_t:");
disp(sys_t.C);
disp("D_t:");
disp(sys_t.D);
disp("----------------------------------------------------------------------------------------------------------------------------------");

// test case 3: inverse transformation returns original ss2ss system
sys_back = ss2ss(sys_t, inv(T));

if norm(sys_back.A - A) < 1D-10 & norm(sys_back.B - B) < 1D-10 & norm(sys_back.C - C) < 1D-10 & norm(sys_back.D - D) < 1D-10 then
    disp("test case 3: ss2ss inverse transformation passed");
else
    error("test case 3 failed");
end

disp("A_back:");
disp(sys_back.A);
disp("B_back:");
disp(sys_back.B);
disp("C_back:");
disp(sys_back.C);
disp("D_back:");
disp(sys_back.D);
disp("----------------------------------------------------------------------------------------------------------------------------------");

// test case 4: 2x2 matrix input transformation
A2 = [0, 1; -2, -3];
B2 = [0; 1];
C2 = [1, 0];
D2 = [0];
T2 = [1, 1; 0, 1];

[A2_t, B2_t, C2_t, D2_t] = ss2ss(A2, B2, C2, D2, T2);
A2_expected = T2 * A2 * inv(T2);
B2_expected = T2 * B2;
C2_expected = C2 * inv(T2);
D2_expected = D2;

if norm(A2_t - A2_expected) < 1D-10 & norm(B2_t - B2_expected) < 1D-10 & norm(C2_t - C2_expected) < 1D-10 & norm(D2_t - D2_expected) < 1D-10 then
    disp("test case 4: ss2ss 2x2 matrix input transformation passed");
else
    error("test case 4 failed");
end

disp("A_t:");
disp(A2_t);
disp("B_t:");
disp(B2_t);
disp("C_t:");
disp(C2_t);
disp("D_t:");
disp(D2_t);
disp("----------------------------------------------------------------------------------------------------------------------------------");

// test case 5: wrong number of ss2ss input arguments
check_error = %f;
try
    ss2ss(A, B, C, D);
catch
    check_error = %t;
end

if check_error then
    disp("test case 5: wrong number of ss2ss input arguments detected passed");
else
    error("test case 5 failed");
end

disp("----------------------------------------------------------------------------------------------------------------------------------");
disp("All ss2ss test cases passed successfully");
