# ss2ss

## Description

`ss2ss` applies a similarity transformation to a continuous-time state-space model.

For a state-space system,

```text
x_dot = A*x + B*u
y     = C*x + D*u
```

the transformed system matrices are computed as:

```text
A_T = inv(T)*A*T
B_T = inv(T)*B
C_T = C*T
D_T = D
```

The function supports both state-space system input and direct matrix input.

## Calling Sequence

```text
sys_t = ss2ss(sys, T)
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T)
```

## Parameters

* **sys** - Input state-space system.
* **A** - State matrix.
* **B** - Input matrix.
* **C** - Output matrix.
* **D** - Feedthrough matrix.
* **T** - State transformation matrix.
* **sys_t** - Transformed state-space system.
* **A_T** - Transformed state matrix.
* **B_T** - Transformed input matrix.
* **C_T** - Transformed output matrix.
* **D_T** - Transformed feedthrough matrix.

## Dependencies

* **sdata.sci** - Extracts the state-space matrices `A`, `B`, `C`, and `D` from the input state-space system.

The dependency file must be executed before the main function while running the unit tests.

```scilab
exec("sdata.sci", -1);
exec("ss2ss.sci", -1);
```

Built-in Scilab functions such as `inv`, `syslin`, `norm`, and `disp` are not listed as dependency files.

---

## Examples

## 1

State-space system input:

```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;

T = [1 0 1; 0 1 1; 1 1 0];

sys = syslin("c", A, B, C, D);
sys_t = ss2ss(sys, T);

disp(sys_t.A);
disp(sys_t.B);
disp(sys_t.C);
disp(sys_t.D);
```

Expected output:

```text
sys_t.A =
   5.    7.    3.
   6.5   8.5   4.5
   3.5   5.5   1.5

sys_t.B =
   4.
   5.
   3.

sys_t.C =
   0.   1.  -1.

sys_t.D =
   0.
```

## 2

Matrix input-output form:

```scilab
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T);

disp(A_T);
disp(B_T);
disp(C_T);
disp(D_T);
```

Expected output:

```text
A_T =
   5.    7.    3.
   6.5   8.5   4.5
   3.5   5.5   1.5

B_T =
   4.
   5.
   3.

C_T =
   0.   1.  -1.

D_T =
   0.
```

## 3

Retransformation check:

```scilab
sys_original = ss2ss(sys_t, inv(T));

disp(sys_original.A);
disp(sys_original.B);
disp(sys_original.C);
disp(sys_original.D);
```

Expected output:

```text
sys_original.A =
   1.   2.   3.
   4.   5.   6.
   7.   8.   9.

sys_original.B =
   1.
   2.
   3.

sys_original.C =
  -1.   0.   1.

sys_original.D =
   0.
```

---

## Test Cases

The following test cases are included in `ss2ss.sci`:

1. State-space system input transformation.
2. Retransformation check.
3. Matrix input-output form.
4. Wrong number of input arguments.
5. Too many output arguments for state-space input.

## Test Results

All test cases passed successfully.

```text
Test Case 1: A matrix transformation passed
Test Case 1: B matrix transformation passed
Test Case 1: C matrix transformation passed
Test Case 1: D matrix transformation passed
Test Case 2: Retransformed A passed
Test Case 2: Retransformed B passed
Test Case 2: Retransformed C passed
Test Case 2: Retransformed D passed
Test Case 3: Matrix input A_T passed
Test Case 3: Matrix input B_T passed
Test Case 3: Matrix input C_T passed
Test Case 3: Matrix input D_T passed
Test Case 4: Wrong number of input arguments detected successfully
Test Case 5: Too many output arguments detected successfully
```

---

## Source Translation Notes

This function follows the source-structure translation of the GNU Octave `ss2ss` function.

The Octave source uses the state-space data extraction line:

```octave
[A, B, C, D] = ssdata(first_in);
```

In this Scilab translation, the equivalent dependency function is used under the `case 2` switch block:

```scilab
[A, B, C, D] = sdata(first_in);
```

The similarity transformation lines are preserved in equivalent Scilab syntax.

```scilab
A_T = inv(T) * A * T;
B_T = inv(T) * B;
C_T = C * T;
D_T = D;
```

`inv` is used as part of the transformation formula and is not treated as a dependency file.

## Compatibility Notes

* The function supports state-space system input and direct matrix input.
* The dependency file `sdata.sci` must be available before executing `ss2ss.sci`.
* The implementation follows Octave source structure while replacing Octave-specific syntax with Scilab syntax.
