```markdown
# zpkdata

## Description
`zpkdata` returns zero-pole-gain data of an LTI system or a real-valued static gain matrix.

## Calling Sequence
```
[z, p, k, tsam] = zpkdata(sys)
[z, p, k, tsam] = zpkdata(sys, "v")
```

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `sys` | LTI / Matrix | Input LTI model or real-valued matrix treated as continuous-time static gain |
| `rtype` | String | Optional. If `"v"` or `"vector"`, returns `z` and `p` as vectors for SISO systems. Default is `"cell"` |
| `z` | List | Zeros for each channel. `z(i,j)` contains zeros from input j to output i |
| `p` | List | Poles for each channel. `p(i,j)` contains poles from input j to output i |
| `k` | Matrix | Gain matrix. `k(i,j)` contains gain from input j to output i |
| `tsam` | Double | Sampling time in seconds. Returns `0` for continuous-time systems |

## Variable Reference

| Variable | Type | Description |
| --- | --- | --- |
| `sys` | LTI / Matrix | Input system |
| `rtype` | String | Return type selector |
| `num` | Matrix | Numerator polynomials extracted from `tfdata` |
| `den` | Matrix | Denominator polynomials extracted from `tfdata` |
| `tsam` | Double | Sampling time |
| `z` | List | Computed zeros per channel |
| `p` | List | Computed poles per channel |
| `k` | Matrix | Computed gain per channel |
| `ny` | Integer | Number of outputs |
| `nu` | Integer | Number of inputs |
| `idx` | Integer | Linear index for list storage |

## Helper Functions

| Function | Purpose |
| --- | --- |
| `__remove_leading_zeros__(p)` | Removes leading zeros from a polynomial coefficient vector |

## Algorithm
1. Set default `rtype = "cell"` if not supplied
2. Check if `sys` is an LTI object. If not, check if it is a real matrix and convert using `syslin("c", sys)`
3. Extract `num`, `den`, `tsam` using `tfdata`
4. Remove leading zeros from each numerator and denominator entry
5. Compute zeros using `roots(num)`
6. Compute poles using `roots(den)`
7. Compute gain as `num(1) / den(1)` for each channel
8. If `rtype` starts with `"v"` and system is SISO, return `z` and `p` directly instead of as lists

## Dependencies
`tfdata`, `syslin`, `roots`, `argn`, `typeof`, `find`, `isempty`, `strncmpi`, `size`

## Files
- `zpkdata.sci`
- `zpkdata_test.sce`
- `README.md`

## How to Run
```scilab
exec("zpkdata.sci", -1);
exec("zpkdata_test.sce", -1);
```

## Test Cases

### Test Case 1 — SISO Transfer Function

```scilab
s = poly(0, "s");
sys = syslin("c", (s + 2) / (s^2 + 4*s + 3));
[z, p, k, tsam] = zpkdata(sys, "v");
```

**Expected output:** `k = 1`, `tsam = 0`, one zero at `-2`, poles at `-1` and `-3`

---

### Test Case 2 — Gain Calculation

```scilab
s = poly(0, "s");
sys = syslin("c", 5*(s + 4) / (s^2 + 8*s + 12));
[z, p, k, tsam] = zpkdata(sys, "v");
```

**Expected output:** `k = 5`, `tsam = 0`

---

### Test Case 3 — State-Space Input

```scilab
A = [-1 0; 0 -2]; B = [1; 1]; C = [1 1]; D = [0];
sys = syslin("c", A, B, C, D);
[z, p, k, tsam] = zpkdata(sys);
```

**Expected output:** `z` and `p` returned as lists

---

### Test Case 4 — Static Gain Matrix

```scilab
sys = [2 3; 4 5];
[z, p, k, tsam] = zpkdata(sys);
```

**Expected output:** `k = [2 3; 4 5]`, `tsam = 0`

---

### Test Case 5 — Invalid Input

```scilab
try
    zpkdata("abc");
catch
    disp("Invalid input detected successfully");
end
```

**Expected output:** Error raised for non-LTI non-matrix input

---

### Test Case 6 — Wrong Number of Arguments

```scilab
try
    zpkdata();
catch
    disp("Wrong number of inputs detected successfully");
end
```

**Expected output:** Error raised for missing input

## Compatibility Notes
This function is a Scilab translation of the GNU Octave Control Package `zpkdata` function. Octave uses cell arrays and `cellfun` for vectorized operations over numerator and denominator entries. Scilab does not support cell arrays, so these are replaced with lists and explicit loops. All variable names and algorithm order are preserved from the original Octave source.
```
