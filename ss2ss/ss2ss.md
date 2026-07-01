# ss2ss
## Description:
* Applies a similarity transformation T to a state-space model.
* Given the state-space model dx/dt = Ax + Bu, y = Cx + Du, and a transformation
  matrix T mapping the state vector x to a new coordinate system, returns the
  equivalent state-space model expressed in the new state vector.
* Not limited to a single calling form: accepts either a full LTI system object
  or the raw A, B, C, D matrices directly.
## Calling Sequence:
* sys_t = ss2ss(sys, T)
* [A_t, B_t, C_t, D_t] = ss2ss(A, B, C, D, T)
## Parameters:
* sys    - State-space LTI system (as returned by syslin)
* T      - Similarity transformation matrix (n-by-n)
* A      - State matrix (n-by-n)
* B      - Input matrix (n-by-m)
* C      - Output (measurement) matrix (p-by-n)
* D      - Feedthrough matrix (p-by-m)
* sys_t  - Transformed state-space system
* A_t, B_t, C_t, D_t - Transformed state-space matrices
## Dependencies:
**ssdata**
## Test Cases
The module includes integrated tests. Run the following to execute them:
```scilab
exec('ssdata.sci', -1);
exec('ss2ss.sci', -1);
```
| Test Case | Description | Expected Logic |
| --- | --- | --- |
| **Test Case 1** | State-space syntax `ss2ss(sys, T)` | Returns transformed A_T, B_T, C_T, D_T matching similarity-transform math |
| **Test Case 2** | Matrix syntax `ss2ss(A, B, C, D, T)` | Returns the same transformed matrices as Test Case 1, via the 5-arg form |
| **Test Case 3** | Reverse transformation `ss2ss(sys_t, inv(T))` | Recovers the original A, B, C, D from the transformed system |
| **Test Case 4** | Identity transformation `ss2ss(sys, eye(A))` | T = I leaves the system unchanged |
| **Test Case 5** | Compare both calling syntaxes | `norm()` of the difference between state-space and matrix syntax outputs is 0 for A, B, C, D |
## Examples
## 1
```
A = [1 2 3;
     4 5 6;
     7 8 9];
B = [1;
     2;
     3];
C = [-1 0 1];
D = 0;
[T, E] = spec(A);
sys = syslin("c", A, B, C, D);
sys_t = ss2ss(sys, T)
```
```
sys_t.A = [3x3 double]
   0.5755207   2.0057583  -0.8179323
   6.6838295   13.61719   -2.5847419
  -4.4755865  -7.8258203   0.8072894
sys_t.B = [3x1 double]
  -0.5788863
  -3.1483145
   1.6307265
sys_t.C = [1x3 double]
   0.8912006  -0.2230866   1.112116
sys_t.D =
   0.
```
## 2
```
[A_t, B_t, C_t, D_t] = ss2ss(A, B, C, D, T)
```
```
A_t = [3x3 double]
   0.5755207   2.0057583  -0.8179323
   6.6838295   13.61719   -2.5847419
  -4.4755865  -7.8258203   0.8072894
B_t = [3x1 double]
  -0.5788863
  -3.1483145
   1.6307265
C_t = [1x3 double]
   0.8912006  -0.2230866   1.112116
D_t =
   0.
```
## 3
```
sys_original = ss2ss(sys_t, inv(T))
```
```
sys_original.A = [3x3 double]
   1.   2.   3.
   4.   5.   6.
   7.   8.   9.
sys_original.B = [3x1 double]
   1.
   2.
   3.
sys_original.C = [1x3 double]
  -1.   0.   1.
sys_original.D =
   0.
```
## 4
```
I = eye(A);
sys_identity = ss2ss(sys, I)
```
```
sys_identity.A = [3x3 double]
   1.   2.   3.
   4.   5.   6.
   7.   8.   9.
sys_identity.B = [3x1 double]
   1.
   2.
   3.
sys_identity.C = [1x3 double]
  -1.   0.   1.
sys_identity.D =
   0.
```
## 5
```
sys_t = ss2ss(sys, T);
[A_t, B_t, C_t, D_t] = ss2ss(A, B, C, D, T);
disp(norm(sys_t.A - A_t));
disp(norm(sys_t.B - B_t));
disp(norm(sys_t.C - C_t));
disp(norm(sys_t.D - D_t));
```
```
 0.
 0.
 0.
 0.
```
