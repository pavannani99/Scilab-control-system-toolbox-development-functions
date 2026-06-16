/* 2026 Author: Pavan Kumar */
function [first_out, second_out, third_out, fourth_out] = ss2ss(first_in, second_in, third_in, fourth_in, fifth_in)

if argn(2) <> 2 & argn(2) <> 5 then
error("ss2ss: wrong number of input arguments");
end

select argn(2)
case 2 then
A = first_in.A;
B = first_in.B;
C = first_in.C;
D = first_in.D;
T = inv(second_in);
case 5 then
A = first_in;
B = second_in;
C = third_in;
D = fourth_in;
T = inv(fifth_in);
end

A_T = inv(T)*A*T;
B_T = inv(T)*B;
C_T = C*T;
D_T = D;

select argn(2)
case 2 then
if argn(1) > 1 then
error("Too many output arguments");
end
first_out = syslin("c", A_T, B_T, C_T, D_T);
case 5 then
if argn(1) > 4 then
error("Too many output arguments");
end
first_out = A_T;
second_out = B_T;
third_out = C_T;
fourth_out = D_T;
end

endfunction

// TEST CASE 1: state-space system input

tol = 1d-10;

A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;

T = [1 0 1; 0 1 1; 1 1 0];

original_system = syslin("c", A, B, C, D);
transformed_system = ss2ss(original_system, T);

A_expected = T*A*inv(T);
B_expected = T*B;
C_expected = C*inv(T);
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

// TEST CASE 5: too many output arguments

try
[out1, out2] = ss2ss(original_system, T);
catch
disp("Test Case 5: Too many output arguments detected successfully");
end
