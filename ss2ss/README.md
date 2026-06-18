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

- `sys` - state-space system
- `A` - state matrix
- `B` - input matrix
- `C` - output matrix
- `D` - feedthrough matrix
- `T` - transformation matrix
- `sys_t` - transformed state-space system
- `A_T` - transformed state matrix
- `B_T` - transformed input matrix
- `C_T` - transformed output matrix
- `D_T` - transformed feedthrough matrix

## Dependencies

- `sdata.sci`

Built-in Scilab functions such as `inv`, `syslin`, `abcd`, `norm`, and `disp` are not listed as dependency files.

## Execution Order

The dependency file must be executed before the main function while running the unit tests.

```scilab
exec("sdata.sci", -1);
exec("ss2ss.sci", -1);
exec("ss2ss_test.sce", -1);
```

The test file `ss2ss_test.sce` already follows this order.

## Source-Structure Translation Notes

The implementation follows the structure of the Octave `ss2ss` source.

| Octave source structure | Scilab translation |
|---|---|
| `nargin` | `argn(2)` |
| `nargout` | `argn(1)` |
| `if (nargin != 2 && nargin != 5)` | `if argn(2) <> 2 & argn(2) <> 5 then` |
| `print_usage()` | `error("ss2ss: wrong number of input arguments")` |
| `switch nargin` | `select argn(2)` |
| `case 2` | `case 2 then` |
| `[A,B,C,D] = ssdata(first_in)` | `[A, B, C, D] = sdata(first_in)` |
| `T = inv(second_in)` | `T = inv(second_in)` |
| `case 5` | `case 5 then` |
| `A = first_in` | `A = first_in` |
| `B = second_in` | `B = second_in` |
| `C = third_in` | `C = third_in` |
| `D = fourth_in` | `D = fourth_in` |
| `T = inv(fifth_in)` | `T = inv(fifth_in)` |
| `A_T = inv(T)*A*T` | `A_T = inv(T) * A * T` |
| `B_T = inv(T)*B` | `B_T = inv(T) * B` |
| `C_T = C*T` | `C_T = C * T` |
| `D_T = D` | `D_T = D` |
| `ss(A_T,B_T,C_T,D_T)` | `syslin("c", A_T, B_T, C_T, D_T)` |

## Test Cases Included

The file `ss2ss_test.sce` includes:

1. State-space system input transformation
2. Retransformation check
3. Matrix input-output form
4. Wrong number of input arguments
5. Too many output arguments for state-space input
