# filtdata

Accesses discrete-time transfer-function data in DSP format — the Scilab implementation of GNU Octave Control package `filtdata.m` by Lukas Reichlin.

`filtdata` returns numerator and denominator coefficients in ascending powers of `z^-1`. The function works for discrete-time transfer-function/state-space systems and real numeric static-gain matrices.

---

## 📐 Calling Sequence

```scilab
[num, den, tsam] = filtdata(sys)
[num, den, tsam] = filtdata(sys, "vector")
```

---

## 📥 Parameters

| Argument | Description |
|---|---|
| `sys` | Discrete-time LTI system or real-valued static-gain matrix |
| `"vector"` or `"v"` | For SISO systems, returns `num` and `den` directly as vectors instead of cells |
| `num` | Numerator coefficients in DSP format, arranged in ascending powers of `z^-1` |
| `den` | Denominator coefficients in DSP format, arranged in ascending powers of `z^-1` |
| `tsam` | Sampling time of the system. For numeric static-gain input, `tsam = -1` |

---

## 🧮 Algorithm

The Octave source structure is followed with Scilab-specific adaptations for type checking, cell handling, and static-gain conversion.

| Step | Operation |
|---|---|
| 1 | Check number of input arguments |
| 2 | If input is not an LTI system, allow only real numeric static-gain matrix |
| 3 | Reject continuous-time systems using `isdt` |
| 4 | Extract numerator, denominator, and sampling time using `tfdata` |
| 5 | Convert numerator and denominator data into cell format when required |
| 6 | Pad numerator and denominator coefficient vectors to equal length |
| 7 | If `rtype` begins with `"v"` and the system is SISO, return direct vectors |

---

## 🔗 Dependencies

The submitted folder contains only `filtdata.sci` and `README.md`.
The following dependency files must be loaded before executing `filtdata.sci`.

| Dependency | Purpose | Repository Link |
|---|---|---|
| `tfdata.sci` | Extracts numerator, denominator, and sampling time from transfer-function/state-space systems | https://github.com/yeoleparesh/Control-system/blob/master/tfdata.sci |
| `isdt.sci` | Checks whether the given LTI system is discrete-time | https://github.com/Harikrishnan-Nair14/Harikrishnan_Nair_CSToolboxFunction_IITBombay/blob/main/isdt.sci |
| `issiso.sci` | Checks whether the given system is SISO | https://github.com/nikithad14/Scilab-control-system-toolbox-development-functions/blob/main/issiso/issiso.sci |

Load the dependency files first, then load `filtdata.sci`:

```scilab
exec("tfdata.sci", -1);
exec("isdt.sci", -1);
exec("issiso.sci", -1);
exec("filtdata.sci", -1);
```

To run the internal test cases:

```scilab
filtdata_test();
```

---

## ✅ Test Cases

### Test 1: SISO discrete-time transfer function, cell output

**Input**

```scilab
z = poly(0, "z");
sys = syslin("d", (z + 2), (z^2 + 3*z + 4));

[num, den, tsam] = filtdata(sys);
```

**Expected Output**

```text
num{1} = [0, 1, 2]
den{1} = [1, 3, 4]
tsam   = 1
```

**Test Result**

```text
Test Case 1: SISO numerator cell output passed
Test Case 1: SISO denominator cell output passed
Test Case 1: sampling time output passed
```

---

### Test 2: SISO discrete-time transfer function, vector output

**Input**

```scilab
z = poly(0, "z");
sys = syslin("d", (z + 2), (z^2 + 3*z + 4));

[num, den, tsam] = filtdata(sys, "vector");
```

**Expected Output**

```text
num  = [0, 1, 2]
den  = [1, 3, 4]
tsam = 1
```

**Test Result**

```text
Test Case 2: SISO vector numerator output passed
Test Case 2: SISO vector denominator output passed
```

---

### Test 3: Real numeric static-gain matrix

**Input**

```scilab
K = [1, 2;
     3, 4];

[num, den, tsam] = filtdata(K);
```

**Expected Output**

```text
num{1,1} = [1]
num{1,2} = [2]
num{2,1} = [3]
num{2,2} = [4]
den{i,j} = [1]
tsam     = -1
```

**Test Result**

```text
Test Case 3: static gain numerator (1,1) passed
Test Case 3: static gain numerator (1,2) passed
Test Case 3: static gain numerator (2,1) passed
Test Case 3: static gain numerator (2,2) passed
Test Case 3: static gain denominator passed
Test Case 3: static gain sampling time passed
```

---

### Test 4: Continuous-time system rejection

**Input**

```scilab
s = poly(0, "s");
sys = syslin("c", (s + 1), (s + 2));

[num, den, tsam] = filtdata(sys);
```

**Expected Output**

```text
Error: lti: filtdata: require discrete-time system
```

**Test Result**

```text
Test Case 4: continuous-time system rejected successfully
```

---

### Test 5: Wrong number of input arguments

**Input**

```scilab
filtdata();
```

**Expected Output**

```text
Error: filtdata: wrong number of input arguments
```

**Test Result**

```text
Test Case 5: wrong number of input arguments detected successfully
```

---

### Test 6: Complex static-gain rejection

**Input**

```scilab
K = [1 + %i, 2];

[num, den, tsam] = filtdata(K);
```

**Expected Output**

```text
Error: filtdata: has to be called with an LTI object or with a real matrix (static gain)
```

**Test Result**

```text
Test Case 6: complex static gain rejected successfully
```

---

## 🧪 Verified Scilab Test Output

The function was tested in Scilab using:

```scilab
exec("tfdata.sci", -1);
exec("isdt.sci", -1);
exec("issiso.sci", -1);
exec("filtdata.sci", -1);

filtdata_test();
```

Observed output:

```text
Running filtdata test cases...
Test Case 1: SISO numerator cell output passed
Test Case 1: SISO denominator cell output passed
Test Case 1: sampling time output passed
Test Case 2: SISO vector numerator output passed
Test Case 2: SISO vector denominator output passed
Test Case 3: static gain numerator (1,1) passed
Test Case 3: static gain numerator (1,2) passed
Test Case 3: static gain numerator (2,1) passed
Test Case 3: static gain numerator (2,2) passed
Test Case 3: static gain denominator passed
Test Case 3: static gain sampling time passed
Test Case 4: continuous-time system rejected successfully
Test Case 5: wrong number of input arguments detected successfully
Test Case 6: complex static gain rejected successfully
All filtdata test cases completed.
```

---

## ⚠️ Compatibility Notes

- The implementation follows the GNU Octave `filtdata.m` algorithm and source flow.
- Scilab-specific changes are used for LTI type detection, static-gain handling, cell-array access, and polynomial padding.
- GNU Octave uses `isa(sys, 'lti')`, `tf(sys, [], -1)`, `cellfun`, and `prepad`; equivalent Scilab helper logic is used in this implementation.
- The dependency `tfdata.sci` is used for numerator, denominator, and sampling-time extraction.
- The dependency `isdt.sci` is used to reject continuous-time systems.
- The dependency `issiso.sci` is used for SISO vector-output mode.

---

## 📁 Files

```text
filtdata/
├── filtdata.sci
└── README.md
```

---

## 📚 References

| Function | Source |
|---|---|
| GNU Octave `filtdata.m` | https://github.com/gnu-octave/pkg-control/blob/main/inst/filtdata.m |
| `tfdata.sci` dependency | https://github.com/yeoleparesh/Control-system/blob/master/tfdata.sci |
| `isdt.sci` dependency | https://github.com/Harikrishnan-Nair14/Harikrishnan_Nair_CSToolboxFunction_IITBombay/blob/main/isdt.sci |
| `issiso.sci` dependency | https://github.com/nikithad14/Scilab-control-system-toolbox-development-functions/blob/main/issiso/issiso.sci |

---

## 👤 Authors

- Original GNU Octave `filtdata`: **Lukas Reichlin**
- `tfdata.sci`: **Paresh Yeole**
- `issiso.sci`: **Nikitha D**
- Scilab translation and integration: **Pavan Kumar**
