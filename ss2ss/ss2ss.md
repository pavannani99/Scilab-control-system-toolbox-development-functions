# ss2ss

## Description

`ss2ss` applies a similarity transformation to a state-space model.

The function can be used either with a complete state-space system or directly with the state-space matrices `A`, `B`, `C`, and `D`.

## Calling Sequence

```scilab
sys_t = ss2ss(sys, T)
```

```scilab
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T)
```

## Parameters

`sys`
State-space system.

`A`
State matrix.

`B`
Input matrix.

`C`
Output matrix.

`D`
Feedthrough matrix.

`T`
Transformation matrix.

`sys_t`
Transformed state-space system.

`A_T`
Transformed state matrix.

`B_T`
Transformed input matrix.

`C_T`
Transformed output matrix.

`D_T`
Transformed feedthrough matrix.

## Method

For the two-input form:

```scilab
sys_t = ss2ss(sys, T)
```

the matrices are extracted from the Scilab state-space system using:

```scilab
A = sys.A
B = sys.B
C = sys.C
D = sys.D
```

For the five-input form:

```scilab
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T)
```

the matrices are taken directly from the input arguments.

The transformed matrices are computed as:

```scilab
A_T = inv(T)*A*T
B_T = inv(T)*B
C_T = C*T
D_T = D
```

Since the Octave implementation internally uses `T = inv(input_T)`, the Scilab translation preserves the same computation order.

## Source Translation Notes

This implementation is based on the Octave Control Package `ss2ss` source structure.

The main variable names are preserved:

`first_in`, `second_in`, `third_in`, `fourth_in`, `fifth_in`

`first_out`, `second_out`, `third_out`, `fourth_out`

`A`, `B`, `C`, `D`, `T`

`A_T`, `B_T`, `C_T`, `D_T`

The Octave line:

```octave
[A,B,C,D] = ssdata(first_in);
```

is translated using Scilab state-space fields:

```scilab
A = first_in.A;
B = first_in.B;
C = first_in.C;
D = first_in.D;
```

The Octave line:

```octave
first_out = ss(A_T,B_T,C_T,D_T);
```

is translated using Scilab `syslin`:

```scilab
first_out = syslin("c", A_T, B_T, C_T, D_T);
```

No wrapper functions are added. The code directly uses Scilab-native state-space syntax.

## Test Cases

The included test cases check:

1. State-space system input transformation.
2. Retransformation back to the original system.
3. Matrix input-output form.
4. Wrong number of input arguments.
5. Too many output arguments.

## Dependencies

`syslin`

`inv`

`norm`

`disp`

`argn`

`error`

## How to Run

Save the file as:

```text
ss2ss.sci
```

Run it in Scilab:

```scilab
exec("ss2ss.sci", -1);
```
