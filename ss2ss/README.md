# ss2ss

## Description

`ss2ss` applies a similarity transformation to a state-space model.

For a state-space system,

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

This implementation follows the GNU Octave / MATLAB convention used in the original `ss2ss` function.

---

## Calling Sequence

```scilab
sys_T = ss2ss(sys, T)
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T)
```

---

## Parameters

| Parameter | Type               | Description                                    |
| --------- | ------------------ | ---------------------------------------------- |
| `sys`     | State-space system | Input system created using `syslin`.           |
| `A`       | Matrix             | State matrix.                                  |
| `B`       | Matrix             | Input matrix.                                  |
| `C`       | Matrix             | Output matrix.                                 |
| `D`       | Matrix             | Feedthrough matrix.                            |
| `T`       | Matrix             | Non-singular similarity transformation matrix. |
| `sys_T`   | State-space system | Transformed state-space system.                |
| `A_T`     | Matrix             | Transformed state matrix.                      |
| `B_T`     | Matrix             | Transformed input matrix.                      |
| `C_T`     | Matrix             | Transformed output matrix.                     |
| `D_T`     | Matrix             | Transformed feedthrough matrix.                |

---

## Dependencies

The function depends on the following external file:

| File         | Purpose                                                                          |
| ------------ | -------------------------------------------------------------------------------- |
| `ssdata.sci` | Extracts the `A`, `B`, `C`, and `D` matrices from a `syslin` state-space system. |

The dependency file must be executed before executing `ss2ss.sci`.

```scilab
exec("ssdata.sci", -1);
exec("ss2ss.sci", -1);
```

The dependency file `ssdata.sci` includes the following required helper functions internally:

| Function       | Purpose                                                                         |
| -------------- | ------------------------------------------------------------------------------- |
| `ssdata`       | Accesses state-space model data.                                                |
| `__sys_data__` | Extracts `A`, `B`, `C`, and `D` from the system structure.                      |
| `__dss2ss__`   | Converts descriptor state-space data to regular state-space form when required. |

Built-in Scilab functions such as `argn`, `inv`, `syslin`, `typeof`, `disp`, `norm`, and `error` are not listed as dependency files.

---

## Source Translation Notes

This function is a Scilab translation of the GNU Octave Control package function `ss2ss`.

Original Octave source:

```text
Copyright (C) 2017 Fabian Alexander Wilms <f.alexander.wilms@gmail.com>
```

The original Octave implementation supports two calling forms:

```text
ss2ss(sys, T)
ss2ss(A, B, C, D, T)
```

In the original Octave source, the input transformation matrix is inverted first:

```text
T = inv(input_T)
```

and then the transformation is applied as:

```text
A_T = inv(T)*A*T
B_T = inv(T)*B
C_T = C*T
D_T = D
```

Therefore, with respect to the user-provided transformation matrix `input_T`, the final transformation becomes:

```text
A_T = input_T*A*inv(input_T)
B_T = input_T*B
C_T = C*inv(input_T)
D_T = D
```

This Scilab implementation preserves the same argument-count handling, transformation convention, and output behavior.

---

## Files

```text
ss2ss/
├── ssdata.sci
├── ss2ss.sci
└── README.md
```

---

## Usage

Load the dependency file first, then load the main function file.

```scilab
exec("ssdata.sci", -1);
exec("ss2ss.sci", -1);
```

The file `ssdata.sci` is required only for the two-input form:

```scilab
sys_T = ss2ss(sys, T)
```

because this form extracts `A`, `B`, `C`, and `D` from the input state-space system using `ssdata`.

---

## Examples

### Example 1 — Matrix Input Form

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

In this form, the input matrices are passed directly to the function, and the transformed matrices are returned separately.

---

### Example 2 — State-Space System Input Form

```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;
T = [1 0 0; 1 1 0; 0 1 1];

sys = syslin("c", A, B, C, D);

sys_T = ss2ss(sys, T);

[A_T, B_T, C_T, D_T] = ssdata(sys_T);

disp(A_T);
disp(B_T);
disp(C_T);
disp(D_T);
```

In this form, the input is a `syslin` state-space system. The function returns a transformed `syslin` system.

---

### Example 3 — Inverse Transformation Check

```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;
T = [1 0 0; 1 1 0; 0 1 1];

sys = syslin("c", A, B, C, D);

sys_T = ss2ss(sys, T);
sys_back = ss2ss(sys_T, inv(T));

[A_back, B_back, C_back, D_back] = ssdata(sys_back);

disp(A_back);
disp(B_back);
disp(C_back);
disp(D_back);
```

This example verifies that applying the inverse transformation recovers the original state-space matrices.

---

## Test Cases

The test cases are included directly below the main `ss2ss` function in `ss2ss.sci`.

No separate `.sce` test file is required.

Run the files in the following order:

```scilab
exec("ssdata.sci", -1);
exec("ss2ss.sci", -1);
```

The file `ssdata.sci` must be executed first because the two-input form of `ss2ss` uses `ssdata` to extract state-space matrices from a `syslin` system.

The test cases verify the behavior of `ss2ss`. The file `ssdata.sci` is used only as a dependency.

---

### Test Case 1 — Matrix Input Transformation

Verifies the five-input calling form:

```scilab
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T)
```

This test checks whether the matrices `A`, `B`, `C`, and `D` are transformed correctly using the similarity transformation.

```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;
T = [1 0 0; 1 1 0; 0 1 1];

[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T);
```

**Expected output:**

* `A_T` is the transformed state matrix.
* `B_T` is the transformed input matrix.
* `C_T` is the transformed output matrix.
* `D_T` remains equal to `D`.

**Observation:**

The function correctly applies:

```text
A_T = T*A*inv(T)
B_T = T*B
C_T = C*inv(T)
D_T = D
```

The test passes when the computed transformed matrices match the expected values.

---

### Test Case 2 — State-Space System Input Transformation

Verifies the two-input calling form:

```scilab
sys_T = ss2ss(sys, T)
```

This test checks whether a `syslin` state-space system is accepted as input and transformed correctly.

```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;
T = [1 0 0; 1 1 0; 0 1 1];

sys = syslin("c", A, B, C, D);

sys_T = ss2ss(sys, T);

[A_T, B_T, C_T, D_T] = ssdata(sys_T);
```

**Expected output:**

* The input `syslin` system is transformed into an equivalent state-space system.
* The transformed system contains the correct `A_T`, `B_T`, `C_T`, and `D_T` matrices.
* The output is a state-space system, not four separate matrices.

**Observation:**

The function correctly uses `ssdata(sys)` to extract the state-space matrices from the input system and then applies the same transformation logic used in the matrix-input form.

This confirms that the dependency `ssdata.sci` is used correctly by `ss2ss`.

---

### Test Case 3 — Inverse Transformation Check

Verifies that applying the inverse transformation to the transformed system recovers the original system.

```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;
T = [1 0 0; 1 1 0; 0 1 1];

sys = syslin("c", A, B, C, D);

sys_T = ss2ss(sys, T);
sys_back = ss2ss(sys_T, inv(T));

[A_back, B_back, C_back, D_back] = ssdata(sys_back);
```

**Expected output:**

* `A_back` should match the original `A`.
* `B_back` should match the original `B`.
* `C_back` should match the original `C`.
* `D_back` should match the original `D`.

**Observation:**

The transformed system remains mathematically equivalent to the original system.

When the inverse transformation is applied, the original state-space matrices are recovered. This verifies that `ss2ss` performs a valid similarity transformation.

---

### Test Case 4 — Second-Order Matrix Transformation

Verifies the function using a smaller second-order system.

```scilab
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];
D = 0;
T = [1 1; 0 1];

[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T);
```

**Expected output:**

* The function should correctly transform a 2x2 state matrix.
* The dimensions of the transformed matrices should remain consistent.
* `D_T` should remain equal to `D`.

**Observation:**

This test confirms that the function works not only for the 3x3 example, but also for a smaller second-order state-space model.

It verifies dimensional consistency and correct transformation behavior for a simple system.

---

### Test Case 5 — Output Argument Validation

Verifies that the two-input form allows only one output argument.

In the original Octave implementation, when `ss2ss(sys, T)` is used, only one transformed system output is allowed. This Scilab translation follows the same behavior.

```scilab
A = [1 2; 3 4];
B = [1; 0];
C = [1 0];
D = 0;
T = [1 0; 1 1];

sys = syslin("c", A, B, C, D);

[A_T, B_T] = ss2ss(sys, T);
```

**Expected output:**

* The function should raise an error because the two-input form should return only one output.
* Multiple output arguments are allowed only for the five-input matrix form.

**Observation:**

The test passes when the function detects too many output arguments and raises the expected error.

This confirms that the Scilab translation preserves the output-argument behavior of the original Octave implementation.

---

## Expected Test Output

When `ss2ss.sci` is executed after loading `ssdata.sci`, the following output is expected:

```text
test case 1: matrix input transformation passed
test case 2: state-space system input transformation passed
test case 3: inverse transformation returns original system passed
test case 4: 2x2 matrix input transformation passed
test case 5: too many output arguments detected passed
All ss2ss test cases passed successfully
```

---

## Test Results

The test cases confirm that:

* The five-input matrix form works correctly.
* The two-input `syslin` form works correctly.
* The local dependency `ssdata.sci` is used correctly for extracting system matrices.
* Applying the inverse transformation recovers the original system.
* Output-argument restrictions are handled correctly.
* No separate `.sce` test file is required because the test cases are included directly inside `ss2ss.sci`.

---

## Variable Reference

| Variable     | Scope         | Type                        | Description                                                                                   |
| ------------ | ------------- | --------------------------- | --------------------------------------------------------------------------------------------- |
| `first_in`   | Main function | Matrix / State-space system | First input argument. It is either `sys` in the two-input form or `A` in the five-input form. |
| `second_in`  | Main function | Matrix                      | Second input argument. It is either `T` in the two-input form or `B` in the five-input form.  |
| `third_in`   | Main function | Matrix                      | Third input argument, used as `C` in the five-input form.                                     |
| `fourth_in`  | Main function | Matrix                      | Fourth input argument, used as `D` in the five-input form.                                    |
| `fifth_in`   | Main function | Matrix                      | Fifth input argument, used as `T` in the five-input form.                                     |
| `lhs`        | Main function | Integer                     | Number of output arguments requested.                                                         |
| `rhs`        | Main function | Integer                     | Number of input arguments supplied.                                                           |
| `A`          | Main function | Matrix                      | Original state matrix.                                                                        |
| `B`          | Main function | Matrix                      | Original input matrix.                                                                        |
| `C`          | Main function | Matrix                      | Original output matrix.                                                                       |
| `D`          | Main function | Matrix                      | Original feedthrough matrix.                                                                  |
| `T`          | Main function | Matrix                      | Inverse of the user-supplied transformation matrix, following the Octave implementation.      |
| `A_T`        | Main function | Matrix                      | Transformed state matrix.                                                                     |
| `B_T`        | Main function | Matrix                      | Transformed input matrix.                                                                     |
| `C_T`        | Main function | Matrix                      | Transformed output matrix.                                                                    |
| `D_T`        | Main function | Matrix                      | Transformed feedthrough matrix.                                                               |
| `first_out`  | Main function | Matrix / State-space system | First output argument.                                                                        |
| `second_out` | Main function | Matrix                      | Second output argument, used only in the five-input form.                                     |
| `third_out`  | Main function | Matrix                      | Third output argument, used only in the five-input form.                                      |
| `fourth_out` | Main function | Matrix                      | Fourth output argument, used only in the five-input form.                                     |

---

## Mathematical Foundation

The function performs a similarity transformation of the state vector.

Original system:

```text
x_dot = A*x + B*u
y     = C*x + D*u
```

Let the transformed state be:

```text
x_bar = T*x
```

Then:

```text
x = inv(T)*x_bar
```

Differentiating:

```text
x_bar_dot = T*x_dot
```

Substituting the original state equation:

```text
x_bar_dot = T*(A*x + B*u)
```

Using `x = inv(T)*x_bar`:

```text
x_bar_dot = T*A*inv(T)*x_bar + T*B*u
```

The output equation becomes:

```text
y = C*inv(T)*x_bar + D*u
```

Therefore, the transformed matrices are:

```text
A_T = T*A*inv(T)
B_T = T*B
C_T = C*inv(T)
D_T = D
```

---

## Compatibility Notes

* The transformation matrix `T` must be non-singular.
* In the two-input form, the function returns a transformed `syslin` state-space system.
* In the five-input form, the function returns the transformed matrices `A_T`, `B_T`, `C_T`, and `D_T`.
* The file `ssdata.sci` is required only for extracting matrices from a `syslin` state-space system.
* The function follows the transformation convention used in the GNU Octave `ss2ss` implementation.
* Passing a singular transformation matrix may cause `inv(T)` to raise an error or produce unreliable numerical results.
* Built-in Scilab functions are not listed as dependency files.

---

## Recommended Usage

For matrix input:

```scilab
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T);
```

For state-space system input:

```scilab
sys_T = ss2ss(sys, T);
```

For checking correctness:

```scilab
sys_back = ss2ss(sys_T, inv(T));
```

If the transformation is valid, the matrices extracted from `sys_back` should match the original system matrices.

---

## References

[1] GNU Octave Control Package, `ss2ss` function.

[2] Fabian Alexander Wilms, original GNU Octave `ss2ss` implementation, 2017.

[3] Goodwin, Graebe, and Salgado, *Control System Design*, page 484, 2000.
