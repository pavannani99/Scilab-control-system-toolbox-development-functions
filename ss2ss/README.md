# ss2ss

## Description

`ss2ss` applies a similarity transformation to a state-space model.

For a state-space model:

```text
x_dot = A*x + B*u
y     = C*x + D*u
```

the transformed matrices are computed as:

```text
A_T = inv(T)*A*T
B_T = inv(T)*B
C_T = C*T
D_T = D
```

## Calling Sequence

```scilab
sys_t = ss2ss(sys, T)
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T)
```

## Parameters

- `sys` - State-space system
- `A` - State matrix
- `B` - Input matrix
- `C` - Output matrix
- `D` - Feedthrough matrix
- `T` - Transformation matrix
- `sys_t` - Transformed state-space system
- `A_T` - Transformed state matrix
- `B_T` - Transformed input matrix
- `C_T` - Transformed output matrix
- `D_T` - Transformed feedthrough matrix

## Dependencies

- `sdata.sci`

## Execution Order

The dependency file must be executed before the main function.

This submission keeps the test cases inside `ss2ss.sci`. The file loads `sdata.sci` before defining and testing `ss2ss`.

Run:

```scilab
exec("ss2ss.sci", -1);
```

## Source Translation Notes

The Octave source uses the state-space data extraction function inside the `case 2` branch.  
In this Scilab translation, the corresponding dependency function is used as:

```scilab
[A, B, C, D] = sdata(first_in);
T = inv(second_in);
```

Built-in Scilab functions such as `inv`, `syslin`, `norm`, and `disp` are not dependency files and are therefore not listed under dependencies.

## Test Cases Included

The file `ss2ss.sci` includes:

1. State-space system input transformation
2. Retransformation check
3. Matrix input-output form
4. Wrong number of input arguments
5. Too many output arguments for state-space input
