/* 2026 Author: Pavan Kumar */
/* ss2ss_test.sce
   Unit tests for ss2ss.sci.
*/

clc;
clear;

exec("sdata.sci", -1);
exec("ss2ss.sci", -1);

tol = 1d-10;

// TEST CASE 1: state-space system input

A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;

T = [1 0 1; 0 1 1; 1 1 0];

original_system = syslin("c", A, B, C, D);
transformed_system = ss2ss(original_system, T);

A_expected = T * A * inv(T);
B_expected = T * B;
C_expected = C * inv(T);
D_expected = D;

if norm(transformed_system.A - A_expected) < tol then
    disp("Test Case 1: A matrix transformation passed");
else
    disp("Test Case 1: A matrix transformation failed");
end

if norm(transformed_system.B - B_expected) < tol then
    disp("Test Case 1: B matrix transformation passed");
else
    disp("Test Case 1: B matrix transformation failed");
end

if norm(transformed_system.C - C_expected) < tol then
    disp("Test Case 1: C matrix transformation passed");
else
    disp("Test Case 1: C matrix transformation failed");
end

if norm(transformed_system.D - D_expected) < tol then
    disp("Test Case 1: D matrix transformation passed");
else
    disp("Test Case 1: D matrix transformation failed");
end

disp("Test Case 1: Transformed A:");
disp(transformed_system.A);

disp("Test Case 1: Transformed B:");
disp(transformed_system.B);

disp("Test Case 1: Transformed C:");
disp(transformed_system.C);

disp("Test Case 1: Transformed D:");
disp(transformed_system.D);

// TEST CASE 2: retransformation check

retransformed_system = ss2ss(transformed_system, inv(T));

if norm(original_system.A - retransformed_system.A) < tol then
    disp("Test Case 2: Retransformed A passed");
else
    disp("Test Case 2: Retransformed A failed");
end

if norm(original_system.B - retransformed_system.B) < tol then
    disp("Test Case 2: Retransformed B passed");
else
    disp("Test Case 2: Retransformed B failed");
end

if norm(original_system.C - retransformed_system.C) < tol then
    disp("Test Case 2: Retransformed C passed");
else
    disp("Test Case 2: Retransformed C failed");
end

if norm(original_system.D - retransformed_system.D) < tol then
    disp("Test Case 2: Retransformed D passed");
else
    disp("Test Case 2: Retransformed D failed");
end

// TEST CASE 3: matrix input-output form

[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T);

if norm(A_T - transformed_system.A) < tol then
    disp("Test Case 3: Matrix input A_T passed");
else
    disp("Test Case 3: Matrix input A_T failed");
end

if norm(B_T - transformed_system.B) < tol then
    disp("Test Case 3: Matrix input B_T passed");
else
    disp("Test Case 3: Matrix input B_T failed");
end

if norm(C_T - transformed_system.C) < tol then
    disp("Test Case 3: Matrix input C_T passed");
else
    disp("Test Case 3: Matrix input C_T failed");
end

if norm(D_T - transformed_system.D) < tol then
    disp("Test Case 3: Matrix input D_T passed");
else
    disp("Test Case 3: Matrix input D_T failed");
end

// TEST CASE 4: wrong number of input arguments

try
    ss2ss(A, B, C);
catch
    disp("Test Case 4: Wrong number of input arguments detected successfully");
end

// TEST CASE 5: too many output arguments for state-space input

try
    [out1, out2] = ss2ss(original_system, T);
catch
    disp("Test Case 5: Too many output arguments detected successfully");
end
