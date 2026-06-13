# ss2ss

## Description

`ss2ss` applies a similarity transformation to a state-space model.

For a state-space system,

```scilab
x_dot = A*x + B*u
y     = C*x + D*u
```

and a transformation matrix `T`, the new state vector is defined as:

```scilab
x_new = T*x
```

The transformed state-space matrices are:

```scilab
A_new = T*A*inv(T)
B_new = T*B
C_new = C*inv(T)
D_new = D
```

The transformed model is equivalent to the original model, but represented in a different state-coordinate system.

## Calling Sequence

```scilab
sys_new = ss2ss(sys, T)
[At, Bt, Ct, Dt] = ss2ss(A, B, C, D, T)
```

## Parameters

### Input Parameters

`sys`
State-space LTI system.

`A`
State matrix of size `n x n`.

`B`
Input matrix of size `n x m`.

`C`
Output matrix of size `p x n`.

`D`
Feedthrough matrix of size `p x m`.

`T`
Nonsingular transformation matrix of size `n x n`.

### Output Parameters

`sys_new`
Transformed state-space system.

`At`
Transformed state matrix.

`Bt`
Transformed input matrix.

`Ct`
Transformed output matrix.

`Dt`
Transformed feedthrough matrix.

## Dependencies

This function uses the following Scilab built-in functions:

```scilab
syslin
svd
find
typeof
size
max
```

No external dependency file is required.

## Test Cases

### Test Case 1: State-space input

```scilab
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];
D = [0];
T = [1 2; 3 4];

sys = syslin("c", A, B, C, D);
sys_t = ss2ss(sys, T);

disp(sys_t.A);
disp(sys_t.B);
disp(sys_t.C);
disp(sys_t.D);
disp(sys_t.dt);
```

Expected result:

```text
A, B, C, and D are transformed using the similarity transformation.
The sampling time remains "c".
```

### Test Case 2: Matrix input-output form

```scilab
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];
D = [0];
T = [1 2; 3 4];

[At, Bt, Ct, Dt] = ss2ss(A, B, C, D, T);

disp(At);
disp(Bt);
disp(Ct);
disp(Dt);
```

Expected result:

```text
At = T*A*inv(T)
Bt = T*B
Ct = C*inv(T)
Dt = D
```

### Test Case 3: Discrete-time state-space system

```scilab
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];
D = [0];
T = [1 2; 3 4];

sysd = syslin(0.1, A, B, C, D);
sysd_t = ss2ss(sysd, T);

disp(sysd_t.A);
disp(sysd_t.B);
disp(sysd_t.C);
disp(sysd_t.D);
disp(sysd_t.dt);
```

Expected result:

```text
The transformed system has the same sampling time as the original discrete-time system.
```

### Test Case 4: Eigenvalue preservation

```scilab
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];
D = [0];
T = [1 2; 3 4];

sys = syslin("c", A, B, C, D);
sys_t = ss2ss(sys, T);

e1 = gsort(spec(A), "g", "i");
e2 = gsort(spec(sys_t.A), "g", "i");

disp(e1);
disp(e2);
```

Expected result:

```text
The eigenvalues of the original A matrix and transformed A matrix are the same.
```

### Test Case 5: Singular transformation matrix

```scilab
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];
D = [0];

sys = syslin("c", A, B, C, D);
T = [1 2; 2 4];

try
    sys_t = ss2ss(sys, T);
catch
    mprintf("Error detected successfully.\n");
end
```

Expected result:

```text
The function should reject a singular transformation matrix.
```

### Test Case 6: Wrong transformation matrix size

```scilab
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];
D = [0];

sys = syslin("c", A, B, C, D);
T = eye(3, 3);

try
    sys_t = ss2ss(sys, T);
catch
    mprintf("Error detected successfully.\n");
end
```

Expected result:

```text
The function should reject a transformation matrix whose size does not match the order of A.
```

### Test Case 7: Non-state-space system input

```scilab
s = poly(0, "s");
G = syslin("c", 1/(s+1));
T = [1 2; 3 4];

try
    sys_t = ss2ss(G, T);
catch
    mprintf("Error detected successfully.\n");
end
```

Expected result:

```text
The two-input form should accept only a state-space system and transformation matrix.
```

### Test Case 8: Wrong number of inputs

```scilab
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];
D = [0];

sys = syslin("c", A, B, C, D);

try
    sys_t = ss2ss(sys);
catch
    mprintf("Error detected successfully.\n");
end
```

Expected result:

```text
The function should reject an invalid number of input arguments.
```

## Notes

This implementation follows the Octave-style similarity transformation convention:

```scilab
x_new = T*x
```

Therefore, the transformed matrices are:

```scilab
At = T*A*inv(T)
Bt = T*B
Ct = C*inv(T)
Dt = D
```

In Scilab, right division by `T` is used to represent multiplication by `inv(T)`:

```scilab
At = T*A/T
Ct = C/T
```

