## Test Cases

The test cases are included directly below the main `ss2ss` function in `ss2ss.sci`.

No separate `.sce` test file is required.

Run the files in the following order:

```scilab
exec("ssdata.sci", -1);
exec("ss2ss.sci", -1);
```

The file `ssdata.sci` must be executed first because `ss2ss(sys, T)` uses `ssdata` to extract the state-space matrices from a `syslin` system.

The test cases verify only the behavior of `ss2ss`. The file `ssdata.sci` is used only as a dependency.

---

### Test Case 1 — Matrix Input Transformation

Verifies the five-input calling form:

```scilab
[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T)
```

This test checks whether the matrices `A`, `B`, `C`, and `D` are transformed correctly using the similarity transformation.

```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;
T = [1 0 0; 1 1 0; 0 1 1];

[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T);
```

**Expected output:**

* The transformed state matrix `A_T` is obtained.
* The transformed input matrix `B_T` is obtained.
* The transformed output matrix `C_T` is obtained.
* The feedthrough matrix `D_T` remains unchanged.

**Observation:**

The function correctly applies the transformation:

```text
A_T = T*A*inv(T)
B_T = T*B
C_T = C*inv(T)
D_T = D
```

The test passes when the computed matrices match the expected transformed matrices.

---

### Test Case 2 — State-Space System Input Transformation

Verifies the two-input calling form:

```scilab
sys_T = ss2ss(sys, T)
```

This test checks whether a `syslin` state-space system is accepted as input and transformed correctly.

```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;
T = [1 0 0; 1 1 0; 0 1 1];

sys = syslin("c", A, B, C, D);
sys_T = ss2ss(sys, T);

[A_T, B_T, C_T, D_T] = ssdata(sys_T);
```

**Expected output:**

* The input `syslin` system is converted into an equivalent transformed state-space system.
* The transformed system contains the correct `A_T`, `B_T`, `C_T`, and `D_T` matrices.
* The output is a state-space system, not four separate matrices.

**Observation:**

The function correctly uses `ssdata(sys)` to extract the state-space matrices from the input system and then applies the same transformation logic used in the matrix-input form.

This confirms that the dependency `ssdata.sci` is being used correctly for the two-input form of `ss2ss`.

---

### Test Case 3 — Inverse Transformation Check

Verifies that applying the inverse transformation to the transformed system recovers the original system.

```scilab
A = [1 2 3; 4 5 6; 7 8 9];
B = [1; 2; 3];
C = [-1 0 1];
D = 0;
T = [1 0 0; 1 1 0; 0 1 1];

sys = syslin("c", A, B, C, D);
sys_T = ss2ss(sys, T);
sys_back = ss2ss(sys_T, inv(T));

[A_back, B_back, C_back, D_back] = ssdata(sys_back);
```

**Expected output:**

* `A_back` should match the original `A`.
* `B_back` should match the original `B`.
* `C_back` should match the original `C`.
* `D_back` should match the original `D`.

**Observation:**

The transformed system remains mathematically equivalent to the original system.

When the inverse transformation is applied, the original state-space matrices are recovered. This verifies that `ss2ss` performs a valid similarity transformation.

---

### Test Case 4 — Second-Order Matrix Transformation

Verifies the function using a smaller second-order system.

```scilab
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];
D = 0;
T = [1 1; 0 1];

[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T);
```

**Expected output:**

* The function should correctly transform a 2x2 state matrix.
* The dimensions of the transformed matrices should remain consistent.
* `D_T` should remain equal to `D`.

**Observation:**

This test confirms that the function works not only for the 3x3 example but also for a smaller second-order state-space model.

It verifies dimensional consistency and correct transformation behavior for a simple system.

---

### Test Case 5 — Output Argument Validation

Verifies that the two-input form allows only one output argument.

In Octave, when `ss2ss(sys, T)` is used, only one transformed system output is allowed. This Scilab translation follows the same behavior.

```scilab
A = [1 2; 3 4];
B = [1; 0];
C = [1 0];
D = 0;
T = [1 0; 1 1];

sys = syslin("c", A, B, C, D);

[A_T, B_T] = ss2ss(sys, T);
```

**Expected output:**

* The function should raise an error because the two-input form should return only one output.
* Multiple output arguments are allowed only for the five-input matrix form.

**Observation:**

The test passes when the function detects too many output arguments and raises the expected error.

This confirms that the Scilab translation preserves the output-argument behavior of the original Octave implementation.

---

### Expected Test Output

When `ss2ss.sci` is executed after loading `ssdata.sci`, the following output is expected:

```text
test case 1: matrix input transformation passed
test case 2: state-space system input transformation passed
test case 3: inverse transformation returns original system passed
test case 4: 2x2 matrix input transformation passed
test case 5: too many output arguments detected passed
All ss2ss test cases passed successfully
```

---

### Test Results

The test cases confirm that:

* The five-input matrix form works correctly.
* The two-input `syslin` form works correctly.
* The local dependency `ssdata.sci` is used correctly for extracting system matrices.
* Applying the inverse transformation recovers the original system.
* Output-argument restrictions are handled correctly.
* No separate `.sce` test file is required because the test cases are included directly inside `ss2ss.sci`.
