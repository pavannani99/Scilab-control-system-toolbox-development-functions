# ss2ss

## Description

`ss2ss` applies a similarity transformation T to a state-space model.

Given the state-space model:

```text
x_dot = A*x + B*u
y     = C*x + D*u
```

and a transformation matrix T that maps the state vector x to another coordinate system:

```text
x_bar = T*x
```

the state-space model is transformed into an equivalent model based on the new state vector:

```text
x_bar_dot = T*A*inv(T)*x_bar + T*B*u
y         = C*inv(T)*x_bar + D*u
```

Note: In the literature, T may instead be defined inversely as `x_bar = inv(T)*x`. This implementation follows the Octave/MATLAB convention.

## Calling Sequence

```scilab
sys_t = ss2ss(sys, T)
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T)
```

## Parameters

* **sys** - State-space system (created using `syslin`).
* **A** - State matrix.
* **B** - Input matrix.
* **C** - Output matrix.
* **D** - Feedthrough matrix.
* **T** - Non-singular similarity transformation matrix.
* **sys_t** - Transformed state-space system.
* **A_T** - Transformed state matrix.
* **B_T** - Transformed input matrix.
* **C_T** - Transformed output matrix.
* **D_T** - Transformed feedthrough matrix.

## Dependencies

* `ssdata.sci` - Authored by Akash S. Required to extract A, B, C, D matrices from a syslin state-space system. Used here as the Scilab equivalent of Octave's `ssdata` data-access function, exactly as referenced in the original Octave source.

The dependency file must be executed before the main function while running the unit tests.

```scilab
exec("ssdata.sci", -1);
exec("ss2ss.sci", -1);
```

Built-in Scilab functions such as `argn`, `inv`, `syslin`, `typeof`, and `disp` are not listed as dependency files.

## Source Translation Notes

This function is a line-by-line Scilab translation of the GNU Octave Control package function `ss2ss`.

Original Octave source (GPL-licensed):
Copyright (C) 2017 Fabian Alexander Wilms <f.alexander.wilms@gmail.com>

The Octave source validates the number of input arguments, branches on two calling modes (2 or 5 inputs), and applies the transformation:

```text
T = inv(input_T)
A_T = inv(T)*A*T   =  input_T * A * inv(input_T)
B_T = inv(T)*B     =  input_T * B
C_T = C*T          =  C * inv(input_T)
D_T = D
```

This Scilab translation preserves the same argument-count branching, the same inversion convention for T, and the same output-argument restrictions per calling mode.

Octave reference:

```octave
function [first_out, second_out, third_out, fourth_out] = ss2ss(first_in, second_in, third_in, fourth_in, fifth_in)

  if (nargin != 2 && nargin != 5)
    print_usage ();
  endif

  switch nargin
    case 2
      [A,B,C,D] = ssdata(first_in);
      T = inv(second_in);
    case 5;
      A = first_in;
      B = second_in;
      C = third_in;
      D = fourth_in;
      T = inv(fifth_in);
  endswitch

  A_T = inv(T)*A*T;
  B_T = inv(T)*B;
  C_T = C*T;
  D_T = D;

  switch nargin
    case 2
      if nargout > 1
        error('Too many output arguments')
      endif
      first_out = ss(A_T,B_T,C_T,D_T);
    case 5
      if nargout > 4
        error('Too many output arguments')
      endif
      first_out = A_T;
      second_out = B_T;
      third_out = C_T;
      fourth_out = D_T;
  endswitch

endfunction
```

## Files

```text
ss2ss/
├── ssdata.sci
├── ss2ss.sci
└── README.md
```

## Usage

Load the dependency first, then load the main function.

```scilab
exec("ssdata.sci", -1);
exec("ss2ss.sci", -1);
```

## Examples

### 1. Matrix input-output form

```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;
T = [1 0 0; 1 1 0; 0 1 1];

[A_t, B_t, C_t, D_t] = ss2ss(A, B, C, D, T);

disp(A_t);
disp(B_t);
disp(C_t);
disp(D_t);
```

### 2. State-space system input form

```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;
T = [1 0 0; 1 1 0; 0 1 1];

sys = syslin("c", A, B, C, D);
sys_t = ss2ss(sys, T);

[A_t, B_t, C_t, D_t] = ssdata(sys_t);

disp(A_t);
disp(B_t);
disp(C_t);
disp(D_t);
```

### 3. Inverse transformation check

```scilab
sys_back = ss2ss(sys_t, inv(T));

[A_back, B_back, C_back, D_back] = ssdata(sys_back);

disp(A_back);  // returns to original A
disp(B_back);  // returns to original B
disp(C_back);  // returns to original C
disp(D_back);  // returns to original D
```

## Test Cases

The test cases are included inside `ss2ss.sci` as the function `ss2ss_test()`.

Run the tests using:

```scilab
exec("ssdata.sci", -1);
exec("ss2ss.sci", -1);
ss2ss_test();
```

| # | Test | What it verifies |
|---|------|-------------------|
| 1 | Matrix input transformation | A, B, C, D matrices transform correctly when called with 5 arguments |
| 2 | State-space system input transformation | `syslin` object transforms correctly when called with 2 arguments |
| 3 | Inverse transformation returns original system | Applying `inv(T)` to the transformed system recovers the original A, B, C, D |
| 4 | Too many output arguments detected | Calling with 2-argument syntax but requesting more than 1 output raises an error |
| 5 | Invalid two-input matrix call detected | Calling `ss2ss(A, B)` with only 2 arguments (neither 2 nor 5 valid inputs in matrix mode) raises an error |

### Expected Test Output

```text
Test 1 passed: matrix input transformation
Test 2 passed: state-space system input transformation
Test 3 passed: inverse transformation returns original system
Test 4 passed: too many output arguments detected
Test 5 passed: invalid two-input matrix call detected
All ss2ss tests passed successfully
```

## Compatibility Notes

* `T` must be a non-singular (invertible) matrix. The function does not check this explicitly; passing a singular T will cause `inv(T)` to error or produce numerically unreliable results, matching Octave's behaviour.
* In the 2-argument form, the output is a continuous- or discrete-time `syslin` object matching the time domain of the input system.
* In the 5-argument form, the four transformed matrices are returned directly without wrapping into a `syslin` object.
