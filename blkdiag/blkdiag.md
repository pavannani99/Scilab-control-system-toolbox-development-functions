# blkdiag

Block-diagonal concatenation of Scilab LTI systems — the Scilab equivalent of GNU Octave Control package `@lti/blkdiag.m` by Lukas Reichlin.

`blkdiag` combines two or more LTI models into one larger block-diagonal state-space model. The main function follows the Octave source structure closely and calls `__sys_group__` for pairwise system grouping.

---

## 📐 Calling Sequence

```scilab
sys = blkdiag(sys1)
sys = blkdiag(sys1, sys2)
sys = blkdiag(sys1, sys2, ..., sysN)
```

---

## 📥 Parameters

| Argument | Description |
|---|---|
| `sys1, sys2, ..., sysN` | Scilab LTI systems created using `syslin`, or numeric static-gain matrices |
| `sys` | Resulting block-diagonal LTI system |

---

## 🧮 Algorithm

The main Octave source is:

```octave
function sys = blkdiag (varargin)

  sys = varargin{1};

  for k = 2 : nargin
    sys = __sys_group__ (sys, varargin{k});
  endfor

endfunction
```

The Scilab translation keeps the same main flow:

```scilab
function sys = blkdiag(varargin)

    sys = varargin(1);

    for k = 2:argn(2)
        sys = __sys_group__(sys, varargin(k));
    end

endfunction
```

The actual block-diagonal matrix construction is performed in `__sys_group__.sci`:

| Matrix | Formula |
|---|---|
| `A` | `[A1, 0; 0, A2]` |
| `B` | `[B1, 0; 0, B2]` |
| `C` | `[C1, 0; 0, C2]` |
| `D` | `[D1, 0; 0, D2]` |

---

## 🔗 Dependencies

### Direct Dependency of `blkdiag.sci`

| File | Purpose | Source |
|---|---|---|
| `__sys_group__.sci` | Performs block-diagonal grouping of two state-space systems | GNU Octave `@ss/__sys_group__.m` |

### Indirect Dependencies Used by `__sys_group__.sci`

| File | Purpose | Source |
|---|---|---|
| `__numeric_to_lti__.sci` | Converts numeric static-gain values into LTI systems | GNU Octave `@lti/__numeric_to_lti__.m` |
| `__lti_group__.sci` | Checks and combines sampling-time information | GNU Octave `@lti/__lti_group__.m` |

Load the files in this order:

```scilab
exec("__numeric_to_lti__.sci", -1);
exec("__lti_group__.sci", -1);
exec("__sys_group__.sci", -1);
exec("blkdiag.sci", -1);
```

The test cases are included inside `blkdiag.sci` as the function `blkdiag_test()`.

To run all tests:

```scilab
blkdiag_test();
```

---

## ✅ Test Cases

### Test 1: Block diagonal concatenation of two continuous-time state-space systems

**Input**

```scilab
A1 = [0, 1;
     -2, -3];
B1 = [0;
      1];
C1 = [1, 0];
D1 = 0;
sys1 = syslin("c", A1, B1, C1, D1);

A2 = [-4];
B2 = [2];
C2 = [3];
D2 = 1;
sys2 = syslin("c", A2, B2, C2, D2);

sys = blkdiag(sys1, sys2);
```

**Expected Output**

```text
A =
[ 0   1   0
 -2  -3   0
  0   0  -4 ]

B =
[ 0   0
  1   0
  0   2 ]

C =
[ 1   0   0
  0   0   3 ]

D =
[ 0   0
  0   1 ]
```

**Test Result**

```text
Test Case 1: A matrix block diagonal passed
Test Case 1: B matrix block diagonal passed
Test Case 1: C matrix block diagonal passed
Test Case 1: D matrix block diagonal passed
```

---

### Test 2: Block diagonal concatenation of three continuous-time systems

**Input**

```scilab
A1 = [0, 1;
     -2, -3];
B1 = [0;
      1];
C1 = [1, 0];
D1 = 0;
sys1 = syslin("c", A1, B1, C1, D1);

A2 = [-4];
B2 = [2];
C2 = [3];
D2 = 1;
sys2 = syslin("c", A2, B2, C2, D2);

A3 = [-5];
B3 = [1];
C3 = [2];
D3 = 3;
sys3 = syslin("c", A3, B3, C3, D3);

sys = blkdiag(sys1, sys2, sys3);
```

**Expected Output**

```text
A =
[ 0   1   0   0
 -2  -3   0   0
  0   0  -4   0
  0   0   0  -5 ]

B =
[ 0   0   0
  1   0   0
  0   2   0
  0   0   1 ]

C =
[ 1   0   0   0
  0   0   3   0
  0   0   0   2 ]

D =
[ 0   0   0
  0   1   0
  0   0   3 ]
```

**Test Result**

```text
Test Case 2: multiple-system A matrix passed
Test Case 2: multiple-system B matrix passed
Test Case 2: multiple-system C matrix passed
Test Case 2: multiple-system D matrix passed
```

---

### Test 3: Single input system

**Input**

```scilab
A1 = [0, 1;
     -2, -3];
B1 = [0;
      1];
C1 = [1, 0];
D1 = 0;

sys1 = syslin("c", A1, B1, C1, D1);

sys = blkdiag(sys1);
```

**Expected Output**

```text
sys.A = A1
sys.B = B1
sys.C = C1
sys.D = D1
```

**Test Result**

```text
Test Case 3: single input A matrix passed
Test Case 3: single input B matrix passed
Test Case 3: single input C matrix passed
Test Case 3: single input D matrix passed
```

---

### Test 4: Dynamic system with numeric static-gain matrix

**Input**

```scilab
A1 = [0, 1;
     -2, -3];
B1 = [0;
      1];
C1 = [1, 0];
D1 = 0;

sys1 = syslin("c", A1, B1, C1, D1);

K = [5, 6];

sys = blkdiag(sys1, K);
```

**Expected Output**

```text
A =
[ 0   1
 -2  -3 ]

B =
[ 0   0   0
  1   0   0 ]

C =
[ 1   0
  0   0 ]

D =
[ 0   0   0
  0   5   6 ]
```

**Test Result**

```text
Test Case 4: numeric static gain A matrix passed
Test Case 4: numeric static gain B matrix passed
Test Case 4: numeric static gain C matrix passed
Test Case 4: numeric static gain D matrix passed
```

---

### Test 5: Discrete-time systems with same sample time

**Input**

```scilab
A1 = [0.5];
B1 = [1];
C1 = [2];
D1 = [0];
sys1 = syslin(0.1, A1, B1, C1, D1);

A2 = [0.2];
B2 = [3];
C2 = [4];
D2 = [5];
sys2 = syslin(0.1, A2, B2, C2, D2);

sys = blkdiag(sys1, sys2);
```

**Expected Output**

```text
A =
[ 0.5   0
  0     0.2 ]

B =
[ 1   0
  0   3 ]

C =
[ 2   0
  0   4 ]

D =
[ 0   0
  0   5 ]
```

**Test Result**

```text
Test Case 5: discrete-time A matrix passed
Test Case 5: discrete-time B matrix passed
Test Case 5: discrete-time C matrix passed
Test Case 5: discrete-time D matrix passed
```

---

### Test 6: Mismatched sampling times

**Input**

```scilab
sys1 = syslin(0.1, [0.5], [1], [2], [0]);
sys2 = syslin(0.2, [0.2], [3], [4], [5]);

sys = blkdiag(sys1, sys2);
```

**Expected Output**

```text
Error: lti_group: systems must have identical sampling times
```

**Test Result**

```text
Test Case 6: mismatched sampling time detected successfully
```

---

### Test 7: Invalid argument

**Input**

```scilab
sys1 = syslin("c", [0, 1; -2, -3], [0; 1], [1, 0], 0);

sys = blkdiag(sys1, "wrong");
```

**Expected Output**

```text
Error: lti: blkdiag: one system is neither an LTI system nor a numeric value
```

**Test Result**

```text
Test Case 7: invalid argument detected successfully
```

---

## 🧪 Verified Scilab Test Output

The function was tested in Scilab using:

```scilab
exec("__numeric_to_lti__.sci", -1);
exec("__lti_group__.sci", -1);
exec("__sys_group__.sci", -1);
exec("blkdiag.sci", -1);
blkdiag_test();
```

Observed output:

```text
Running blkdiag test cases...
Test Case 1: A matrix block diagonal passed
Test Case 1: B matrix block diagonal passed
Test Case 1: C matrix block diagonal passed
Test Case 1: D matrix block diagonal passed
Test Case 2: multiple-system A matrix passed
Test Case 2: multiple-system B matrix passed
Test Case 2: multiple-system C matrix passed
Test Case 2: multiple-system D matrix passed
Test Case 3: single input A matrix passed
Test Case 3: single input B matrix passed
Test Case 3: single input C matrix passed
Test Case 3: single input D matrix passed
Test Case 4: numeric static gain A matrix passed
Test Case 4: numeric static gain B matrix passed
Test Case 4: numeric static gain C matrix passed
Test Case 4: numeric static gain D matrix passed
Test Case 5: discrete-time A matrix passed
Test Case 5: discrete-time B matrix passed
Test Case 5: discrete-time C matrix passed
Test Case 5: discrete-time D matrix passed
Test Case 6: mismatched sampling time detected successfully
Test Case 7: invalid argument detected successfully
All blkdiag test cases completed.
```

---

## ⚠️ Compatibility Notes

- The main `blkdiag.sci` file is kept as a close line-by-line translation of GNU Octave `@lti/blkdiag.m`.
- Octave uses object fields such as `sys.a`, `sys.b`, `sys.c`, `sys.d`, `sys.lti`, and `sys.stname`.
- Scilab `syslin` uses `sys.A`, `sys.B`, `sys.C`, `sys.D`, and `sys.dt`, so helper functions adapt the internal object access while preserving the same block-diagonal output behaviour.
- Octave metadata fields such as input names, output names, input groups, output groups, and state names are not directly reproduced because Scilab `syslin` does not store the same LTI metadata structure.
- Descriptor matrix `E` handling from Octave `@ss/__sys_group__.m` is not implemented for regular Scilab `syslin` models, since the current implementation targets standard state-space models with `A`, `B`, `C`, and `D`.
- Numeric static-gain inputs are supported by converting them into static LTI systems before grouping.

---

## 📁 Files

```text
blkdiag/
├── __numeric_to_lti__.sci
├── __lti_group__.sci
├── __sys_group__.sci
├── blkdiag.sci
└── README.md
```

---

## 📚 References

| Function | GNU Octave Source |
|---|---|
| `blkdiag` | https://github.com/gnu-octave/pkg-control/blob/main/inst/%40lti/blkdiag.m |
| `__sys_group__` | https://github.com/gnu-octave/pkg-control/blob/main/inst/%40ss/__sys_group__.m |
| `__numeric_to_lti__` | https://github.com/gnu-octave/pkg-control/blob/main/inst/%40lti/__numeric_to_lti__.m |
| `__lti_group__` | https://github.com/gnu-octave/pkg-control/blob/main/inst/%40lti/__lti_group__.m |

---

## 👤 Authors

- Original `blkdiag` and `__sys_group__`: **Lukas Reichlin**
- Original `__numeric_to_lti__`: **Torsten Lilge**
- Scilab translation and integration: **Pavan Kumar**
