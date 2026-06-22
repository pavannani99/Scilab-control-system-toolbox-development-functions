/* Copyright (C) 2009-2016 Lukas F. Reichlin */
/*
This file is part of LTI Syncope.

LTI Syncope is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LTI Syncope is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
*/

/*
Form a block transfer matrix of sys with x copies vertically and
y copies horizontally. If y is not specified, it is set to x.

Author: Lukas Reichlin <lukas.reichlin@gmail.com>
Created: May 2014
Version: 0.1
2026 Scilab translation: ALLU RAM CHARAN
*/

funcprot(0);

function sys = repmat(sys, x, y)

    rhs = argn(2);

    select rhs
    case 2 then
        if is_real_scalar(x) then
            y = x;
        elseif is_real_vector(x) & length(x) == 2 then
            y = x(2);
            x = x(1);
        else
            error("lti: repmat: second argument invalid");
        end

    case 3 then
        if ~is_real_scalar(x, y) then
            error("lti: repmat: dimensions ''m'' and ''n'' must be real integers");
        end

    else
        error("repmat: wrong number of input arguments");
    end

    [p, m] = size(sys);

    out_idx = __repmat_index__(1:p, x);
    in_idx = __repmat_index__(1:m, y);

    sys = __sys_prune__(sys, out_idx, in_idx);

endfunction


function bool = is_real_scalar(varargin)

    rhs = argn(2);
    bool = %t;

    for k = 1:rhs
        value = varargin(k);

        if type(value) <> 1 then
            bool = %f;
            return;
        end

        if isempty(value) | size(value, "*") <> 1 then
            bool = %f;
            return;
        end

        if imag(value) <> 0 then
            bool = %f;
            return;
        end
    end

endfunction


function bool = is_real_vector(varargin)

    rhs = argn(2);
    bool = %t;

    for k = 1:rhs
        value = varargin(k);

        if type(value) <> 1 then
            bool = %f;
            return;
        end

        if isempty(value) then
            bool = %f;
            return;
        end

        if size(value, 1) <> 1 & size(value, 2) <> 1 then
            bool = %f;
            return;
        end

        if or(imag(value) <> 0) then
            bool = %f;
            return;
        end
    end

endfunction


function idx = __repmat_index__(base_idx, count)

    if ~is_real_scalar(count) | count < 0 | count <> fix(count) then
        error("lti: repmat: dimensions ''m'' and ''n'' must be real integers");
    end

    idx = [];

    for k = 1:count
        idx = [idx, base_idx];
    end

endfunction


// Test Case 1: repmat(sys, m, n) for a SISO transfer function
s = poly(0, "s");
sys1 = syslin("c", s + 1, s + 2);
rsys1 = repmat(sys1, 2, 3);

[p1, m1] = size(rsys1);
if p1 <> 2 | m1 <> 3 then
    error("Test Case 1 failed: incorrect output size");
end

for i = 1:2
    for j = 1:3
        if norm(coeff(rsys1.num(i, j)) - coeff(sys1.num)) > 1D-10 then
            error("Test Case 1 failed: numerator mismatch");
        end
        if norm(coeff(rsys1.den(i, j)) - coeff(sys1.den)) > 1D-10 then
            error("Test Case 1 failed: denominator mismatch");
        end
    end
end

mprintf("Test Case 1: repmat(sys, m, n) passed\n");


// Test Case 2: repmat(sys, m) shorthand
sys2 = syslin("c", s + 3, s + 4);
rsys2 = repmat(sys2, 2);
[p2, m2] = size(rsys2);

if p2 <> 2 | m2 <> 2 then
    error("Test Case 2 failed");
end

mprintf("Test Case 2: repmat(sys, m) passed\n");


// Test Case 3: repmat(sys, [m, n]) vector form
sys3 = syslin("c", s + 5, s + 6);
rsys3 = repmat(sys3, [3, 1]);
[p3, m3] = size(rsys3);

if p3 <> 3 | m3 <> 1 then
    error("Test Case 3 failed");
end

mprintf("Test Case 3: repmat(sys, [m, n]) passed\n");


// Test Case 4: MIMO state-space system and channel-order verification
A4 = [-1, 0; 0, -2];
B4 = [1, 2; 3, 4];
C4 = [5, 6; 7, 8];
D4 = [9, 10; 11, 12];
X04 = [0.25; -0.5];
sys4 = syslin("c", A4, B4, C4, D4, X04);
rsys4 = repmat(sys4, 2, 3);

[p4, m4] = size(rsys4);
if p4 <> 4 | m4 <> 6 then
    error("Test Case 4 failed: incorrect output size");
end

if norm(rsys4.A - A4) > 1D-10 then
    error("Test Case 4 failed: A matrix changed");
end

if norm(rsys4.B - [B4, B4, B4]) > 1D-10 then
    error("Test Case 4 failed: B matrix mismatch");
end

if norm(rsys4.C - [C4; C4]) > 1D-10 then
    error("Test Case 4 failed: C matrix mismatch");
end

if norm(rsys4.D - [D4, D4, D4; D4, D4, D4]) > 1D-10 then
    error("Test Case 4 failed: D matrix mismatch");
end

if norm(rsys4.X0 - X04) > 1D-10 then
    error("Test Case 4 failed: initial state changed");
end

mprintf("Test Case 4: MIMO state-space repetition passed\n");


// Test Case 5: invalid second argument
err_flag = %f;
try
    repmat(sys1, [2, 3, 4]);
catch
    err_flag = %t;
end

if ~err_flag then
    error("Test Case 5 failed: invalid argument was accepted");
end

mprintf("Test Case 5: invalid second argument detected\n");


// Test Case 6: non-integer repetition dimension
err_flag = %f;
try
    repmat(sys1, 2.5, 2);
catch
    err_flag = %t;
end

if ~err_flag then
    error("Test Case 6 failed: non-integer dimension was accepted");
end

mprintf("Test Case 6: non-integer dimension detected\n");


// Test Case 7: wrong number of input arguments
err_flag = %f;
try
    repmat(sys1);
catch
    err_flag = %t;
end

if ~err_flag then
    error("Test Case 7 failed: wrong number of inputs was accepted");
end

mprintf("Test Case 7: wrong number of input arguments detected\n");
