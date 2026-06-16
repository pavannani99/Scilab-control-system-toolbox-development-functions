# ss2ss

## Description

* Applies a similarity transformation to a state-space model.

* Supports both state-space system input and direct matrix input.

* For a state-space model,

  ```
  x_dot = A*x + B*u
  y     = C*x + D*u
  ```

  the transformed matrices are computed as:

  ```
  A_T = inv(T)*A*T
  B_T = inv(T)*B
  C_T = C*T
  D_T = D
  ```

* The implementation follows the Octave `ss2ss` source structure, while replacing Octave-specific functions with Scilab equivalents.

## Calling Sequence

* `sys_t = ss2ss(sys, T)`
* `[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T)`

## Parameters

* `sys` - State-space system
* `A` - State matrix
* `B` - Input matrix
* `C` - Output matrix
* `D` - Feedthrough matrix
* `T` - Transformation matrix
* `sys_t` - Transformed state-space system
* `A_T` - Transformed state matrix
* `B_T` - Transformed input matrix
* `C_T` - Transformed output matrix
* `D_T` - Transformed feedthrough matrix

## Dependencies

* `syslin`
* `inv`
* `norm`
* `disp`

## Source Translation Notes

* The Octave source uses `ssdata(first_in)` to extract state-space matrices.

* In Scilab, the same matrices are accessed directly using:

  ```
  first_in.A
  first_in.B
  first_in.C
  first_in.D
  ```

* The Octave source uses `ss(A_T,B_T,C_T,D_T)` to create the transformed state-space system.

* In Scilab, this is replaced with:

  ```
  syslin("c", A_T, B_T, C_T, D_T)
  ```

* The main variable names from the Octave source are preserved:

  ```
  first_in, second_in, third_in, fourth_in, fifth_in
  first_out, second_out, third_out, fourth_out
  A, B, C, D, T
  A_T, B_T, C_T, D_T
  ```

## Examples

## 1

```
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;

T = [1 0 1; 0 1 1; 1 1 0];

original_system = syslin("c", A, B, C, D);
transformed_system = ss2ss(original_system, T);

disp(transformed_system.A);
disp(transformed_system.B);
disp(transformed_system.C);
disp(transformed_system.D);
```

```
transformed_system.A =
   5.    7.    3.
   6.5   8.5   4.5
   3.5   5.5   1.5

transformed_system.B =
   4.
   5.
   3.

transformed_system.C =
   0.   1.  -1.

transformed_system.D =
   0.
```

## 2

```
retransformed_system = ss2ss(transformed_system, inv(T));

disp(retransformed_system.A);
disp(retransformed_system.B);
disp(retransformed_system.C);
disp(retransformed_system.D);
```

```
retransformed_system.A =
   1.   2.   3.
   4.   5.   6.
   7.   8.   9.

retransformed_system.B =
   1.
   2.
   3.

retransformed_system.C =
  -1.   0.   1.

retransformed_system.D =
   0.
```

## 3

```
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T);

disp(A_T);
disp(B_T);
disp(C_T);
disp(D_T);
```

```
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

## 4

```
try
    ss2ss(A, B, C);
catch
    disp("Test Case 4: Wrong number of input arguments detected successfully");
end
```

```
Test Case 4: Wrong number of input arguments detected successfully
```

## 5

```
try
    [out1, out2] = ss2ss(original_system, T);
catch
    disp("Test Case 5: Too many output arguments detected successfully");
end
```

```
Test Case 5: Too many output arguments detected successfully
```
