```markdown
# ss2ss

## Description
`ss2ss` applies a similarity transformation to a state-space model.

## Calling Sequence

```
sys_t = ss2ss(sys, T)
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T)
```

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `sys` | LTI | Input state-space system |
| `T` | Matrix | Similarity transformation matrix |
| `A, B, C, D` | Matrix | State-space matrices (used in 5-argument form) |
| `sys_t` | LTI | Transformed state-space system (2-argument form) |
| `A_T, B_T, C_T, D_T` | Matrix | Transformed matrices (5-argument form) |

## Variable Reference

| Variable | Type | Description |
| --- | --- | --- |
| `A` | Matrix | State matrix extracted from `sys` |
| `B` | Matrix | Input matrix extracted from `sys` |
| `C` | Matrix | Output matrix extracted from `sys` |
| `D` | Matrix | Feedthrough matrix extracted from `sys` |
| `T` | Matrix | Inverse of the input transformation matrix |
| `A_T` | Matrix | Transformed state matrix: `inv(T) * A * T` |
| `B_T` | Matrix | Transformed input matrix: `inv(T) * B` |
| `C_T` | Matrix | Transformed output matrix: `C * T` |
| `D_T` | Matrix | Feedthrough matrix: unchanged from `D` |

## Algorithm
1. Validate number of input arguments (must be 2 or 5)
2. For 2-argument form: extract `A, B, C, D` from `sys`, compute `T = inv(second_in)`
3. For 5-argument form: use `A, B, C, D` directly, compute `T = inv(fifth_in)`
4. Apply transformation: `A_T = inv(T)*A*T`, `B_T = inv(T)*B`, `C_T = C*T`, `D_T = D`
5. For 2-argument form: return transformed system using `syslin`
6. For 5-argument form: return `A_T, B_T, C_T, D_T` directly

## Dependencies
`syslin`, `inv`, `argn`, `error`, `norm`

## Files
- `ss2ss.sci`
- `ss2ss_test.sce`
- `README.md`

## How to Run

```scilab
exec("ss2ss.sci", -1);
exec("ss2ss_test.sce", -1);
```

## Test Cases

### Test Case 1 — State-Space System Input
```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;
T = [1 0 1; 0 1 1; 1 1 0];
sys = syslin("c", A, B, C, D);
transformed_system = ss2ss(sys, T);
```
**Expected:** All four matrices transformed correctly

---

### Test Case 2 — Retransformation Check
```scilab
retransformed_system = ss2ss(transformed_system, inv(T));
```
**Expected:** Retransformed system matches original `A, B, C, D`

---

### Test Case 3 — Matrix Input Form
```scilab
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T);
```
**Expected:** Output matrices match transformed system from Test Case 1

---

### Test Case 4 — Wrong Number of Input Arguments
```scilab
try
    ss2ss(A, B, C);
catch
    disp("Wrong number of input arguments detected successfully");
end
```
**Expected:** Error raised

---

### Test Case 5 — Too Many Output Arguments
```scilab
try
    [out1, out2] = ss2ss(sys, T);
catch
    disp("Too many output arguments detected successfully");
end
```
**Expected:** Error raised

## Compatibility Notes
Scilab translation of GNU Octave Control Package `ss2ss`. Variable names `first_in`, `second_in` etc. are used in the function signature to handle both 2-argument and 5-argument calling forms cleanly. All transformation logic matches the original Octave source.
```
