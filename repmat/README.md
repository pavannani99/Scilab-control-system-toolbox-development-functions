# repmat

## Description:
- Forms a block LTI system by repeating an input system vertically and horizontally.
- `repmat(sys, 2, 3)` produces two vertical copies and three horizontal copies of `sys`.
- The implementation follows the source structure and behaviour of GNU Octave Control package `@lti/repmat`.

## Calling Sequence:

```scilab
sys = repmat(sys, m)
sys = repmat(sys, [m, n])
sys = repmat(sys, m, n)
```

## Parameters:
- `sys` - Input Scilab LTI system represented as a transfer-function or state-space `syslin` object.
- `m` - Number of vertical repetitions; it must be a non-negative integer.
- `n` - Number of horizontal repetitions; it must be a non-negative integer. If omitted, `n = m`.
- Returned `sys` - Repeated block LTI system.

## Dependencies:
- `__sys_prune__.sci`
- Execute `__sys_prune__.sci` before `repmat.sci`.
- `is_real_scalar`, `is_real_vector`, and `__repmat_index__` are local helper functions included in `repmat.sci`.

## Execution:

```scilab
exec("__sys_prune__.sci", -1);
exec("repmat.sci", -1);
```

Executing `repmat.sci` defines the function and runs the test cases written below it.

# Examples

## 1

```scilab
s = poly(0, "s");
sys = syslin("c", s + 1, s + 2);
rsys = repmat(sys, 2, 3);
size(rsys)
```

## Expected Output

```text
2.  3.
```

## 2

```scilab
A = [-1, 0; 0, -2];
B = [1, 2; 3, 4];
C = [5, 6; 7, 8];
D = [9, 10; 11, 12];
sys = syslin("c", A, B, C, D);
rsys = repmat(sys, 2, 3);
size(rsys)
```

## Expected Output

```text
4.  6.
```

The state dynamics matrix `A` is preserved. The input matrix `B` is repeated horizontally, the output matrix `C` is repeated vertically, and `D` is repeated in both directions.

## Test Cases:
- Test Case 1 verifies the three-argument form using a SISO transfer function.
- Test Case 2 verifies the scalar shorthand `repmat(sys, m)`.
- Test Case 3 verifies the vector form `repmat(sys, [m, n])`.
- Test Case 4 verifies MIMO state-space channel ordering and preservation of `A` and `X0`.
- Test Case 5 checks an invalid dimension vector.
- Test Case 6 checks a non-integer repetition dimension.
- Test Case 7 checks an invalid number of input arguments.

## Files:

```text
repmat/
├── __sys_prune__.sci
├── repmat.sci
└── README.md
```

## Author:
- Original Octave author: Lukas F. Reichlin
- 2026 Scilab translation: ALLU RAM CHARAN
