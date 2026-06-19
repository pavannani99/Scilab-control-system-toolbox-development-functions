# ss2ss

## Description

`ss2ss` applies a similarity transformation to a state-space system.

For a state-space model,

```text
x_dot = A*x + B*u
y     = C*x + D*u
```

and a non-singular transformation matrix `T`, the state vector is transformed as:

```text
x_bar = T*x
```

The equivalent transformed state-space model is:

```text
x_bar_dot = T*A*inv(T)*x_bar + T*B*u
y         = C*inv(T)*x_bar + D*u
```

This implementation follows the GNU Octave/MATLAB convention used in the original `ss2ss` function.

## Calling Sequence

```scilab
sys_t = ss2ss(sys, T)
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T)
```

## Parameters

* **sys** - State-space system created using `syslin`.
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

* **ssdata.sci** - Required to extract the `A`, `B`, `C`, and `D` matrices from a `syslin` state-space system.

The dependency file `ssdata.sci` must be executed before executing `ss2ss.sci`.

```scilab
exec("ssdata.sci", -1);
exec("ss2ss.sci", -1);
```

The file `ssdata.sci` includes the following required helper functions internally:

```text
ssdata
__sys_data__
__dss2ss__
```

Built-in Scilab functions such as `argn`, `inv`, `syslin`, `typeof`, `disp`, and `norm` are not listed as dependency files.

## Source Translation Notes

This function is a Scilab translation of the GNU Octave Control package function `ss2ss`.

Original Octave source:

```text
Copyright (C) 2017 Fabian Alexander Wilms <f.alexander.wilms@gmail.com>
```

The Octave implementation supports two calling forms:

```text
ss2ss(sys, T)
ss2ss(A, B, C, D, T)
```

The original Octave source first stores the inverse of the input transformation matrix:

```text
T = inv(input_T)
```

and then applies:

```text
A_T = inv(T)*A*T
B_T = inv(T)*B
C_T = C*T
D_T = D
```

Therefore, with respect to the user-provided transformation matrix `input_T`, the transformation becomes:

```text
A_T = input_T*A*inv(input_T)
B_T = input_T*B
C_T = C*inv(input_T)
D_T = D
```

This Scilab version preserves the same argument-count handling, transformation convention, and output behavior.

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

### 1. Matrix Input Form

```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;
T = [1 0 0; 1 1 0; 0 1 1];

[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T);

disp(A_T);
disp(B_T);
disp(C_T);
disp(D_T);
```

### 2. State-Space System Input Form

```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;
T = [1 0 0; 1 1 0; 0 1 1];

sys = syslin("c", A, B, C, D);
sys_t = ss2ss(sys, T);

[A_T, B_T, C_T, D_T] = ssdata(sys_t);

disp(A_T);
disp(B_T);
disp(C_T);
disp(D_T);
```

### 3. Inverse Transformation Check

```scilab
sys_back = ss2ss(sys_t, inv(T));

[A_back, B_back, C_back, D_back] = ssdata(sys_back);

disp(A_back);
disp(B_back);
disp(C_back);
disp(D_back);
```

## Test Cases

The test cases are included directly below the main `ss2ss` function in `ss2ss.sci`.

No separate `.sce` test file is required.

Run the files as:

```scilab
exec("ssdata.sci", -1);
exec("ss2ss.sci", -1);
```

After the main function is loaded, the test cases written below the function are executed automatically.

| # | Test Case                               | What It Verifies                                                                                                           |
| - | --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| 1 | Matrix input transformation             | Verifies that `A`, `B`, `C`, and `D` are transformed correctly when the function is called with five input arguments.      |
| 2 | State-space system input transformation | Verifies that a `syslin` state-space system is transformed correctly when the function is called with two input arguments. |
| 3 | Inverse transformation check            | Verifies that applying `inv(T)` to the transformed system recovers the original state-space matrices.                      |
| 4 | Second-order matrix transformation      | Verifies the transformation on a smaller 2x2 state-space example.                                                          |
| 5 | Output argument validation              | Verifies that the two-input form allows only one output argument.                                                          |

## Expected Test Output

```text
test case 1: matrix input transformation passed
test case 2: state-space system input transformation passed
test case 3: inverse transformation returns original system passed
test case 4: 2x2 matrix input transformation passed
test case 5: too many output arguments detected passed
All ss2ss test cases passed successfully
```

## Compatibility Notes

* The transformation matrix `T` must be non-singular.
* In the two-input form, the function returns a transformed `syslin` state-space system.
* In the five-input form, the function returns the transformed matrices `A_T`, `B_T`, `C_T`, and `D_T`.
* The function depends on `ssdata.sci` only for extracting state-space matrices from a `syslin` system.
