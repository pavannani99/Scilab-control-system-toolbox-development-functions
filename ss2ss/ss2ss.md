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
| `A, B, C, D` | Matrix | State-space matrices for 5-argument form |
| `sys_t` | LTI | Transformed state-space system |
| `A_T, B_T, C_T, D_T` | Matrix | Transformed state-space matrices |

## Algorithm
1. Validate number of input arguments — must be 2 or 5
2. For 2-argument form: extract `A, B, C, D` from `sys`
3. For 5-argument form: use `A, B, C, D` directly
4. Compute `T = inv(transformation matrix)`
5. Apply: `A_T = inv(T)*A*T`, `B_T = inv(T)*B`, `C_T = C*T`, `D_T = D`
6. Return transformed system via `syslin` for 2-argument form, or raw matrices for 5-argument form

## Dependencies
`syslin`, `inv`, `argn`, `error`

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
sys_t = ss2ss(sys, T);
```
**Expected:** All four matrices correctly transformed

---

### Test Case 2 — Retransformation Check
```scilab
sys_orig = ss2ss(sys_t, inv(T));
```
**Expected:** Retransformed system matches original A, B, C, D

---

### Test Case 3 — Matrix Input Form
```scilab
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T);
```
**Expected:** Output matrices match Test Case 1 results

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
Scilab translation of GNU Octave Control Package `ss2ss`. All transformation logic and variable names match the original Octave source.
```
