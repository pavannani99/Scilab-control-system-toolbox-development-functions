# blkdiag

Block-diagonal concatenation of Scilab LTI systems — the Scilab equivalent of the GNU Octave Control package `@lti/blkdiag.m` by Lukas Reichlin.

`blkdiag` combines two or more LTI systems into a larger block-diagonal state-space model. The implementation follows the same iterative grouping approach as the GNU Octave implementation and relies on helper functions for system grouping and sampling-time compatibility.

---

# 📐 Calling Sequence

```scilab
sys = blkdiag(sys1)
sys = blkdiag(sys1, sys2)
sys = blkdiag(sys1, sys2, ..., sysN)
```

---

# 📥 Parameters

| Argument                | Description                                                                |
| ----------------------- | -------------------------------------------------------------------------- |
| `sys1, sys2, ..., sysN` | Scilab LTI systems created using `syslin`, or numeric static-gain matrices |
| `sys`                   | Resulting block-diagonal LTI system                                        |

---

# 🔗 Dependencies

## Direct Dependency

| File                             | Purpose                                                     | Source                           |
| -------------------------------- | ----------------------------------------------------------- | -------------------------------- |
| `DEPENDENCIES/__sys_group__.sci` | Performs block-diagonal grouping of two state-space systems | GNU Octave `@ss/__sys_group__.m` |

## Indirect Dependencies

| File                                  | Purpose                                                | Source                                 |
| ------------------------------------- | ------------------------------------------------------ | -------------------------------------- |
| `DEPENDENCIES/__numeric_to_lti__.sci` | Converts numeric static-gain matrices into LTI systems | GNU Octave `@lti/__numeric_to_lti__.m` |
| `DEPENDENCIES/__lti_group__.sci`      | Checks sampling-time compatibility                     | GNU Octave `@lti/__lti_group__.m`      |

Load the files in the following order:

```scilab
exec("DEPENDENCIES/__numeric_to_lti__.sci",-1);
exec("DEPENDENCIES/__lti_group__.sci",-1);
exec("DEPENDENCIES/__sys_group__.sci",-1);
exec("blkdiag.sci",-1);
```

The test cases are included inside `blkdiag.sci` as the function:

```scilab
blkdiag_test_simplified();
```

Run the tests using:

```scilab
blkdiag_test_simplified();
```

---

# ✅ Test Cases

## Test 1 — Continuous-time block diagonal concatenation

**Input**

```scilab
A1 = [0,1;-2,-3];
B1 = [0;1];
C1 = [1,0];
D1 = 0;
sys1 = syslin("c",A1,B1,C1,D1);

A2 = [-4];
B2 = [2];
C2 = [3];
D2 = 1;
sys2 = syslin("c",A2,B2,C2,D2);

sys = blkdiag(sys1,sys2);
```

**Verification**

```scilab
norm(sys.A-[A1,[0;0];[0,0],A2]) < 1d-8
```

**Expected Output**

```text
T
```

---

## Test 2 — Multiple system concatenation

**Input**

```scilab
sys3 = syslin("c",[-5],[1],[2],3);

sys_all = blkdiag(sys1,sys2,sys3);
```

**Verification**

```scilab
size(sys_all.A,1)==4
```

**Expected Output**

```text
T
```

---

## Test 3 — Single system input

**Input**

```scilab
sys_single = blkdiag(sys1);
```

**Verification**

```scilab
norm(sys_single.A-A1) < 1d-8
```

**Expected Output**

```text
T
```

---

## Test 4 — Static gain concatenation

**Input**

```scilab
K=[5,6];

sys_static=blkdiag(sys1,K);
```

**Verification**

```scilab
size(sys_static.D,2)==3
```

**Expected Output**

```text
T
```

---

## Test 5 — Discrete-time systems

**Input**

```scilab
dsys1=syslin(0.1,[0.5],[1],[2],[0]);
dsys2=syslin(0.1,[0.25],[3],[4],[1]);

dsys=blkdiag(dsys1,dsys2);
```

**Verification**

```scilab
norm(dsys.A-[0.5,0;0,0.25]) < 1d-8
```

**Expected Output**

```text
T
```

---

## Test 6 — Continuous/discrete system mismatch

**Input**

```scilab
blkdiag(sys1,dsys1);
```

**Expected Output**

```text
Error generated
```

**Verification**

```scilab
err6 == %t
```

---

## Test 7 — Invalid input type

**Input**

```scilab
blkdiag(sys1,"invalid");
```

**Expected Output**

```text
Error generated
```

**Verification**

```scilab
err7 == %t
```

---

# 🧪 Verified Scilab Test Output

The implementation was verified in Scilab using:

```scilab
exec("DEPENDENCIES/__numeric_to_lti__.sci",-1);
exec("DEPENDENCIES/__lti_group__.sci",-1);
exec("DEPENDENCIES/__sys_group__.sci",-1);
exec("blkdiag.sci",-1);

blkdiag_test_simplified();
```

Observed output:

```text
Test 1: T
Test 2: T
Test 3: T
Test 4: T
Test 5: T
Test 6: T
Test 7: T
```

---

# ⚠️ Compatibility Notes

* The implementation follows the GNU Octave `@lti/blkdiag.m` interface.
* Pairwise block-diagonal grouping is delegated to `__sys_group__.sci`.
* Numeric static-gain matrices are automatically converted into LTI systems before grouping.
* Continuous-time and discrete-time compatibility checks are handled by `__lti_group__.sci`.
* Scilab `syslin` objects store only the standard state-space matrices (`A`, `B`, `C`, `D`) and sampling time (`dt`).
* GNU Octave LTI metadata such as state names, input names, output names, input groups, output groups, and descriptor matrix `E` are not reproduced because they are not part of the standard Scilab `syslin` representation.

---

# 📁 Files

```text
blkdiag/
├── DEPENDENCIES/
│   ├── __numeric_to_lti__.sci
│   ├── __lti_group__.sci
│   └── __sys_group__.sci
├── blkdiag.sci
└── README.md
```

---

# 📚 References

| Function             | GNU Octave Source                                                                    |
| -------------------- | ------------------------------------------------------------------------------------ |
| `blkdiag`            | https://github.com/gnu-octave/pkg-control/blob/main/inst/%40lti/blkdiag.m            |
| `__sys_group__`      | https://github.com/gnu-octave/pkg-control/blob/main/inst/%40ss/__sys_group__.m       |
| `__numeric_to_lti__` | https://github.com/gnu-octave/pkg-control/blob/main/inst/%40lti/__numeric_to_lti__.m |
| `__lti_group__`      | https://github.com/gnu-octave/pkg-control/blob/main/inst/%40lti/__lti_group__.m      |

---

# 👤 Authors

* Original `blkdiag`: **Lukas Reichlin**
* Original `__sys_group__`: **Lukas Reichlin**
* Original `__numeric_to_lti__`: **Torsten Lilge**
* Scilab translation and integration: **Pavan Kumar**
