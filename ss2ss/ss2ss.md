The markdown is correct but your editor might not be rendering it. Here it is as clean plain text you can paste directly:

---

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
| `rtype` | String | Optional. If `"v"`, returns `z` and `p` as vectors for SISO systems. Default is `"cell"` |
| `z` | List | Zeros for each channel |
| `p` | List | Poles for each channel |
| `k` | Matrix | Gain matrix |
| `tsam` | Double | Sampling time. Returns `0` for continuous-time systems |

## Variable Reference

| Variable | Type | Description |
| --- | --- | --- |
| `num` | Matrix | Numerator polynomials from `tfdata` |
| `den` | Matrix | Denominator polynomials from `tfdata` |
| `ny` | Integer | Number of outputs |
| `nu` | Integer | Number of inputs |
| `idx` | Integer | Linear index for list storage |

## Helper Functions

| Function | Purpose |
| --- | --- |
| `__remove_leading_zeros__(p)` | Removes leading zeros from a polynomial coefficient vector |

## Algorithm
1. Set default `rtype = "cell"` if not supplied
2. Check if `sys` is LTI. If not, check if real matrix and convert using `syslin("c", sys)`
3. Extract `num`, `den`, `tsam` using `tfdata`
4. Remove leading zeros from each numerator and denominator entry
5. Compute zeros using `roots(num)`
6. Compute poles using `roots(den)`
7. Compute gain as `num(1) / den(1)` per channel
8. If `rtype` starts with `"v"` and system is SISO, return `z` and `p` directly

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
**Expected:** `k = 1`, `tsam = 0`, zero at `-2`, poles at `-1` and `-3`

---

### Test Case 2 — Gain Calculation
```scilab
s = poly(0, "s");
sys = syslin("c", 5*(s + 4) / (s^2 + 8*s + 12));
[z, p, k, tsam] = zpkdata(sys, "v");
```
**Expected:** `k = 5`, `tsam = 0`

---

### Test Case 3 — State-Space Input
```scilab
A = [-1 0; 0 -2]; B = [1; 1]; C = [1 1]; D = [0];
sys = syslin("c", A, B, C, D);
[z, p, k, tsam] = zpkdata(sys);
```
**Expected:** `z` and `p` returned as lists

---

### Test Case 4 — Static Gain Matrix
```scilab
sys = [2 3; 4 5];
[z, p, k, tsam] = zpkdata(sys);
```
**Expected:** `k = [2 3; 4 5]`, `tsam = 0`

---

### Test Case 5 — Invalid Input
```scilab
try
    zpkdata("abc");
catch
    disp("Invalid input detected successfully");
end
```
**Expected:** Error raised

---

### Test Case 6 — Wrong Number of Arguments
```scilab
try
    zpkdata();
catch
    disp("Wrong number of inputs detected successfully");
end
```
**Expected:** Error raised

## Compatibility Notes
Scilab translation of GNU Octave Control Package `zpkdata`. Octave cell arrays and `cellfun` are replaced with Scilab lists and explicit loops. All variable names and algorithm order are preserved from the original Octave source.
