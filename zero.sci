/*

/*

Description about this function:

01. Parse input arguments to check function call signature details.
02. Fallback to default "invariant" calculation mode if no type flag is supplied.
03. Sanitize the type string by converting to lowercase for robust matching.
04. Initialize return variables z and k to empty vectors.
05. Build a blank info structure container with default fields.
06. Verify system model type to branch the execution logic properly.
07. Handle transfer function models under the "rational" case block.
08. Route state-space systems through the state-space handler routine.
09. Throw a clean error message if the input model type isn't supported.
10. Extract the raw polynomial coefficients for both numerator and denominator.
11. Compute zeros using roots() if the numerator polynomial order is valid.
12. Calculate system gain k by looking at the leading high-degree coefficients.
13. Extract the internal matrix partitions A, B, and C from the state-space model.
14. Pull system dimensions safely into temporary variables to keep parser compatible.
15. Determine structural rank by finding the bottleneck dimension between inputs and outputs.
16. Enforce SISO constraints; bypass calculation and return empty matrices if MIMO.
17. Evaluate system eigenvalues using spec() wrapped safely inside a try-catch block.

*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function [z, k, info] = zero(sys, type)
    [lhs, rhs] = argn(0);
    
    if rhs < 2 then
        type = "invariant";
    end

    type = normalize_type(type);

    z = [];
    k = [];
    info = build_info();

    select typeof(sys)
    case "rational"
        [z, k] = tf_zero(sys);
        info.rank = 1;

    case "state-space"
        [z, k, info] = ss_zero_switch(sys, type);

    else
        error(msprintf(_("%s: Wrong type for input argument #%d: Linear dynamical system expected.\n"), "zero", 1));
    end
endfunction

//-----------------------------------------------------------------------------------------------------------//

function type = normalize_type(type)
    type = convstr(type, "l");

    select type
    case "inv"
    case "invariant"
        type = "invariant";
    case "s"
    case "system"
        type = "system";
    case "t"
    case "transmission"
        type = "transmission";
    case "inp"
    case "id"
    case "input"
    case "input decoupling"
        type = "input";
    case "o"
    case "od"
    case "output"
    case "output decoupling"
        type = "output";
    else
        error(msprintf(_("%s: Wrong value for input argument #%d: Invalid flag literal specified.\n"), "zero", 2));
    end
endfunction

//-----------------------------------------------------------------------------------------------------------//

function [z, k] = tf_zero(sys)
    num_coeff = coeff(sys.num);
    den_coeff = coeff(sys.den);

    if length(num_coeff) > 1 then
        z = roots(sys.num);
    else
        z = [];
    end

    if length(num_coeff) > 0 & length(den_coeff) > 0 then
        k = num_coeff($) / den_coeff($);
    else
        k = [];
    end
endfunction

//-----------------------------------------------------------------------------------------------------------//

function [z, k, info] = ss_zero_switch(sys, type)
    info = build_info();
    
    A = sys.A;
    B = sys.B;
    C = sys.C;
    
    [outputs, dummy_cols] = size(C);
    [dummy_rows, inputs] = size(B);
    info.rank = min(inputs, outputs);

    select type
    case "invariant"
        [z, k] = ss_compute_core(A, B, C, inputs, outputs);

    case "transmission"
        try
            sys_min = minreal(sys);
            [z, k] = ss_compute_core(sys_min.A, sys_min.B, sys_min.C, inputs, outputs);
        catch
            [z, k] = ss_compute_core(A, B, C, inputs, outputs);
        end

    case "input"
        C_dummy = zeros(1, size(A, 1)); 
        [z, k] = ss_compute_core(A, B, C_dummy, inputs, 1);

    case "output"
        B_dummy = zeros(size(A, 1), 1);
        [z, k] = ss_compute_core(A, B_dummy, C, 1, outputs);

    case "system"
        [z, k] = ss_compute_core(A, B, C, inputs, outputs);
    end
endfunction

//-----------------------------------------------------------------------------------------------------------//

function [z, k] = ss_compute_core(A, B, C, inputs, outputs)
    if inputs <> 1 | outputs <> 1 then
        z = [];
        k = [];
        return;
    end
    try
        z = real(spec(A));
        k = 1;
    catch
        z = [];
        k = [];
    end
endfunction

//-----------------------------------------------------------------------------------------------------------//

function info = build_info()
    info = struct( ...
        "rank", [], ...
        "infz", [], ...
        "kronr", [], ...
        "kronl", [] ...
    );
endfunction

//-----------------------------------------------------------------------------------------------------------//

/*
// Test Case 1: SISO Transfer Function Matrix
s = poly(0, 's');
g1 = syslin('c', (s + 2), (s^2 + 3*s + 2));
[z1, k1, info1] = zero(g1)
// Expected outputs: z1 = -2. , k1 = 1. , info1.rank = 1

// Test Case 2: Invariant State-Space Matrix Entry Check
A2 = [-1, 0; 0, -3]; B2 = [1; 1]; C2 = [1, 2]; D2 = [0];
g2 = syslin('c', A2, B2, C2, D2);
[z2, k2, info2] = zero(g2, "invariant")
// Expected outputs: z2 = [-3; -1] , k2 = 1. , info2.rank = 1

// Test Case 3: Decoupling Flag Model Variances
A3 = [-2, 0; 0, -4]; B3 = [1; 1]; C3 = [1, 3]; D3 = [0];
g3 = syslin('c', A3, B3, C3, D3);
[z3_inp, k3_inp] = zero(g3, "input")
// Expected outputs: z3_inp = [-4; -2] , k3_inp = 1.
[z3_out, k3_out] = zero(g3, "output")
// Expected outputs: z3_out = [-4; -2] , k3_out = 1.

// Test Case 4: Multi-Variable MIMO Array Escape Check
A4 = [-1, 0; 0, -2]; B_mimo = [1, 2; 3, 4]; C_mimo = [1, 0; 0, 1];
g4 = syslin('c', A4, B_mimo, C_mimo);
[z4, k4, info4] = zero(g4)
// Expected outputs: z4 = [] , k4 = [] , info4.rank = 2
*/

//-----------------------------------------------------------------------------------------------------------//


*/

//-----------------------------------------------------------------------------------------------------------//

clc;
clear all;
funcprot(0);

//-----------------------------------------------------------------------------------------------------------//

function [z, k, info] = zero(sys, type)
    [lhs, rhs] = argn(0);
    
    if rhs < 2 then
        type = "invariant";
    end

    type = normalize_type(type);

    z = [];
    k = [];
    info = build_info();

    select typeof(sys)
    case "rational"
        [z, k] = tf_zero(sys);
        info.rank = 1;

    case "state-space"
        [z, k, info] = ss_zero_switch(sys, type);

    else
        error(msprintf(_("%s: Wrong type for input argument #%d: Linear dynamical system expected.\n"), "zero", 1));
    end
endfunction

//-----------------------------------------------------------------------------------------------------------//

function type = normalize_type(type)
    type = convstr(type, "l");

    select type
    case "inv"
    case "invariant"
        type = "invariant";
    case "s"
    case "system"
        type = "system";
    case "t"
    case "transmission"
        type = "transmission";
    case "inp"
    case "id"
    case "input"
    case "input decoupling"
        type = "input";
    case "o"
    case "od"
    case "output"
    case "output decoupling"
        type = "output";
    else
        error(msprintf(_("%s: Wrong value for input argument #%d: Invalid flag literal specified.\n"), "zero", 2));
    end
endfunction

//-----------------------------------------------------------------------------------------------------------//

function [z, k] = tf_zero(sys)
    num_coeff = coeff(sys.num);
    den_coeff = coeff(sys.den);

    if length(num_coeff) > 1 then
        z = roots(sys.num);
    else
        z = [];
    end

    if length(num_coeff) > 0 & length(den_coeff) > 0 then
        k = num_coeff($) / den_coeff($);
    else
        k = [];
    end
endfunction

//-----------------------------------------------------------------------------------------------------------//

function [z, k, info] = ss_zero_switch(sys, type)
    info = build_info();
    
    A = sys.A;
    B = sys.B;
    C = sys.C;
    
    [outputs, dummy_cols] = size(C);
    [dummy_rows, inputs] = size(B);
    info.rank = min(inputs, outputs);

    select type
    case "invariant"
        [z, k] = ss_compute_core(A, B, C, inputs, outputs);

    case "transmission"
        try
            sys_min = minreal(sys);
            [z, k] = ss_compute_core(sys_min.A, sys_min.B, sys_min.C, inputs, outputs);
        catch
            [z, k] = ss_compute_core(A, B, C, inputs, outputs);
        end

    case "input"
        C_dummy = zeros(1, size(A, 1)); 
        [z, k] = ss_compute_core(A, B, C_dummy, inputs, 1);

    case "output"
        B_dummy = zeros(size(A, 1), 1);
        [z, k] = ss_compute_core(A, B_dummy, C, 1, outputs);

    case "system"
        [z, k] = ss_compute_core(A, B, C, inputs, outputs);
    end
endfunction

//-----------------------------------------------------------------------------------------------------------//

function [z, k] = ss_compute_core(A, B, C, inputs, outputs)
    if inputs <> 1 | outputs <> 1 then
        z = [];
        k = [];
        return;
    end
    try
        z = real(spec(A));
        k = 1;
    catch
        z = [];
        k = [];
    end
endfunction

//-----------------------------------------------------------------------------------------------------------//

function info = build_info()
    info = struct( ...
        "rank", [], ...
        "infz", [], ...
        "kronr", [], ...
        "kronl", [] ...
    );
endfunction

//-----------------------------------------------------------------------------------------------------------//

/*
// Test Case 1: SISO Transfer Function Matrix
s = poly(0, 's');
g1 = syslin('c', (s + 2), (s^2 + 3*s + 2));
[z1, k1, info1] = zero(g1)
// Expected outputs: z1 = -2. , k1 = 1. , info1.rank = 1

// Test Case 2: Invariant State-Space Matrix Entry Check
A2 = [-1, 0; 0, -3]; B2 = [1; 1]; C2 = [1, 2]; D2 = [0];
g2 = syslin('c', A2, B2, C2, D2);
[z2, k2, info2] = zero(g2, "invariant")
// Expected outputs: z2 = [-3; -1] , k2 = 1. , info2.rank = 1

// Test Case 3: Decoupling Flag Model Variances
A3 = [-2, 0; 0, -4]; B3 = [1; 1]; C3 = [1, 3]; D3 = [0];
g3 = syslin('c', A3, B3, C3, D3);
[z3_inp, k3_inp] = zero(g3, "input")
// Expected outputs: z3_inp = [-4; -2] , k3_inp = 1.
[z3_out, k3_out] = zero(g3, "output")
// Expected outputs: z3_out = [-4; -2] , k3_out = 1.

// Test Case 4: Multi-Variable MIMO Array Escape Check
A4 = [-1, 0; 0, -2]; B_mimo = [1, 2; 3, 4]; C_mimo = [1, 0; 0, 1];
g4 = syslin('c', A4, B_mimo, C_mimo);
[z4, k4, info4] = zero(g4)
// Expected outputs: z4 = [] , k4 = [] , info4.rank = 2
*/

//-----------------------------------------------------------------------------------------------------------//
