function sys = blkdiag(varargin)

if argn(2) < 1 then
error("blkdiag: wrong number of input arguments");
end

sys = varargin(1);

for k = 2:argn(2)
sys = sys_group(sys, varargin(k));
end

endfunction

function sys = sys_group(sys1, sys2)

if typeof(sys1) <> "state-space" & typeof(sys1) <> "linear_system" then
error("blkdiag: arguments must be LTI systems");
end

if typeof(sys2) <> "state-space" & typeof(sys2) <> "linear_system" then
error("blkdiag: arguments must be LTI systems");
end

if sys1.dt <> sys2.dt then
error("blkdiag: systems must have the same sampling time");
end

A = [sys1.A, zeros(size(sys1.A, 1), size(sys2.A, 2));
zeros(size(sys2.A, 1), size(sys1.A, 2)), sys2.A];

B = [sys1.B, zeros(size(sys1.B, 1), size(sys2.B, 2));
zeros(size(sys2.B, 1), size(sys1.B, 2)), sys2.B];

C = [sys1.C, zeros(size(sys1.C, 1), size(sys2.C, 2));
zeros(size(sys2.C, 1), size(sys1.C, 2)), sys2.C];

D = [sys1.D, zeros(size(sys1.D, 1), size(sys2.D, 2));
zeros(size(sys2.D, 1), size(sys1.D, 2)), sys2.D];

sys = syslin(sys1.dt, A, B, C, D);

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
disp("Test Case 4: Single input system A passed");
else
disp("Test Case 4: Single input system A failed");
end

if norm(sys.B - sys1.B) < tol then
disp("Test Case 4: Single input system B passed");
else
disp("Test Case 4: Single input system B failed");
end

if norm(sys.C - sys1.C) < tol then
disp("Test Case 4: Single input system C passed");
else
disp("Test Case 4: Single input system C failed");
end

if norm(sys.D - sys1.D) < tol then
disp("Test Case 4: Single input system D passed");
else
disp("Test Case 4: Single input system D failed");
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
