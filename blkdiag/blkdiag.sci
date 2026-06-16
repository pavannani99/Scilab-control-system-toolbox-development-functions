/* 2026 Author: Pavan Kumar */
/* blkdiag.sci
creates block-diagonal concatenation of LTI models */
/*
Description:
Applies block-diagonal concatenation to LTI systems.
The function combines two or more state-space systems into a single block-diagonal system.

Calling Sequence:
sys = blkdiag(sys1, sys2, ..., sysN)

Parameters:
sys1, sys2, sysN - state-space systems
sys               - block-diagonal state-space system

Dependencies:
Uses Scilab built-ins syslin, zeros, size, norm and disp.
*/

function sys = blkdiag(varargin)


if argn(2) < 1 then
    error("blkdiag: wrong number of input arguments");
end

sys = varargin(1);

for k = 2:argn(2)

    s1 = sys;
    s2 = varargin(k);

    if s1.dt <> s2.dt then
        error("blkdiag: systems must have the same sampling time");
    end

    A = [s1.A, zeros(size(s1.A, 1), size(s2.A, 2));
         zeros(size(s2.A, 1), size(s1.A, 2)), s2.A];

    B = [s1.B, zeros(size(s1.B, 1), size(s2.B, 2));
         zeros(size(s2.B, 1), size(s1.B, 2)), s2.B];

    C = [s1.C, zeros(size(s1.C, 1), size(s2.C, 2));
         zeros(size(s2.C, 1), size(s1.C, 2)), s2.C];

    D = [s1.D, zeros(size(s1.D, 1), size(s2.D, 2));
         zeros(size(s2.D, 1), size(s1.D, 2)), s2.D];

    sys = syslin(s1.dt, A, B, C, D);

end


endfunction

// TEST CASE 1: two continuous-time state-space systems

tol = 1d-10;

sys1 = syslin("c", [-1], [1], [2], [0]);
sys2 = syslin("c", [-2], [3], [4], [5]);

sys = blkdiag(sys1, sys2);

A_expected = [-1 0; 0 -2];
B_expected = [1 0; 0 3];
C_expected = [2 0; 0 4];
D_expected = [0 0; 0 5];

if norm(sys.A - A_expected) < tol then
disp("Test Case 1: A matrix passed");
else
disp("Test Case 1: A matrix failed");
end

if norm(sys.B - B_expected) < tol then
disp("Test Case 1: B matrix passed");
else
disp("Test Case 1: B matrix failed");
end

if norm(sys.C - C_expected) < tol then
disp("Test Case 1: C matrix passed");
else
disp("Test Case 1: C matrix failed");
end

if norm(sys.D - D_expected) < tol then
disp("Test Case 1: D matrix passed");
else
disp("Test Case 1: D matrix failed");
end

disp("Test Case 1: Block diagonal A:");
disp(sys.A);
disp("Test Case 1: Block diagonal B:");
disp(sys.B);
disp("Test Case 1: Block diagonal C:");
disp(sys.C);
disp("Test Case 1: Block diagonal D:");
disp(sys.D);

// TEST CASE 2: three continuous-time state-space systems

sys1 = syslin("c", [-1], [1], [1], [0]);
sys2 = syslin("c", [-2], [2], [2], [0]);
sys3 = syslin("c", [-3], [3], [3], [0]);

sys = blkdiag(sys1, sys2, sys3);

A_expected = [-1 0 0; 0 -2 0; 0 0 -3];
B_expected = [1 0 0; 0 2 0; 0 0 3];
C_expected = [1 0 0; 0 2 0; 0 0 3];
D_expected = [0 0 0; 0 0 0; 0 0 0];

if norm(sys.A - A_expected) < tol then
disp("Test Case 2: A matrix passed");
else
disp("Test Case 2: A matrix failed");
end

if norm(sys.B - B_expected) < tol then
disp("Test Case 2: B matrix passed");
else
disp("Test Case 2: B matrix failed");
end

if norm(sys.C - C_expected) < tol then
disp("Test Case 2: C matrix passed");
else
disp("Test Case 2: C matrix failed");
end

if norm(sys.D - D_expected) < tol then
disp("Test Case 2: D matrix passed");
else
disp("Test Case 2: D matrix failed");
end

disp("Test Case 2: Block diagonal A:");
disp(sys.A);
disp("Test Case 2: Block diagonal B:");
disp(sys.B);
disp("Test Case 2: Block diagonal C:");
disp(sys.C);
disp("Test Case 2: Block diagonal D:");
disp(sys.D);

// TEST CASE 3: discrete-time systems with same sampling time

sys1 = syslin(0.1, [0.5], [1], [1], [0]);
sys2 = syslin(0.1, [0.2], [2], [3], [4]);

sys = blkdiag(sys1, sys2);

A_expected = [0.5 0; 0 0.2];
B_expected = [1 0; 0 2];
C_expected = [1 0; 0 3];
D_expected = [0 0; 0 4];

if norm(sys.A - A_expected) < tol then
disp("Test Case 3: A matrix passed");
else
disp("Test Case 3: A matrix failed");
end

if norm(sys.B - B_expected) < tol then
disp("Test Case 3: B matrix passed");
else
disp("Test Case 3: B matrix failed");
end

if norm(sys.C - C_expected) < tol then
disp("Test Case 3: C matrix passed");
else
disp("Test Case 3: C matrix failed");
end

if norm(sys.D - D_expected) < tol then
disp("Test Case 3: D matrix passed");
else
disp("Test Case 3: D matrix failed");
end

disp("Test Case 3: Discrete-time block diagonal A:");
disp(sys.A);
disp("Test Case 3: Discrete-time block diagonal B:");
disp(sys.B);
disp("Test Case 3: Discrete-time block diagonal C:");
disp(sys.C);
disp("Test Case 3: Discrete-time block diagonal D:");
disp(sys.D);

// TEST CASE 4: single system input

sys1 = syslin("c", [-5], [2], [3], [1]);

sys = blkdiag(sys1);

if norm(sys.A - sys1.A) < tol then
disp("Test Case 4: Single input system passed");
else
disp("Test Case 4: Single input system failed");
end

disp("Test Case 4: Single system A:");
disp(sys.A);
disp("Test Case 4: Single system B:");
disp(sys.B);
disp("Test Case 4: Single system C:");
disp(sys.C);
disp("Test Case 4: Single system D:");
disp(sys.D);

// TEST CASE 5: different sampling times

try
sys1 = syslin(0.1, [0.5], [1], [1], [0]);
sys2 = syslin(0.2, [0.3], [1], [1], [0]);
sys = blkdiag(sys1, sys2);
catch
disp("Test Case 5: Different sampling time detected successfully");
end
