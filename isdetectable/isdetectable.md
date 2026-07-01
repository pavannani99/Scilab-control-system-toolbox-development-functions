# isdetectable

## Description

Checks whether a continuous-time or discrete-time linear system is detectable.

A system is **detectable** if every unstable mode is observable. Equivalently, all unobservable modes must be stable.

This function supports both standard state-space systems and descriptor systems. The implementation follows the GNU Octave Control Package and determines detectability by invoking `isstabilizable` on the transposed system.

---

## Calling Sequence

```text
bool = isdetectable(sys)
bool = isdetectable(sys, tol)

bool = isdetectable(A, C)
bool = isdetectable(A, C, E)
bool = isdetectable(A, C, [], tol)
bool = isdetectable(A, C, E, tol)
bool = isdetectable(A, C, [], [], dflg)
bool = isdetectable(A, C, E, [], dflg)
bool = isdetectable(A, C, [], tol, dflg)
bool = isdetectable(A, C, E, tol, dflg)
```

---

## Parameters

* **sys** - State-space system.
* **A** - State transition matrix.
* **C** - Output (measurement) matrix.
* **E** - Descriptor matrix. If omitted or empty (`[]`), the identity matrix is assumed.
* **tol** - Optional stability tolerance. Default value is `0`.
* **dflg** - System type flag.
  * `0` : Continuous-time system (default).
  * `1` : Discrete-time system.
* **bool** - Logical output.
  * `1` : System is detectable.
  * `0` : System is not detectable.

---

## Dependencies

* `isstabilizable`
* `isct` (only when an LTI system is supplied)

---

# Test Cases

## Test Case 1

```scilab
A = [-1 0;
      0 2];

C = [1 1];

bool = isdetectable(A,C);
disp(bool);
```

**Output**

```text
1
```

---

## Test Case 2

```scilab
A = [-2 0;
      0 -3];

C = [1 0];

bool = isdetectable(A,C);
disp(bool);
```

**Output**

```text
1
```

---

## Test Case 3

```scilab
A = [2 0;
     0 -1];

C = [0 1];

bool = isdetectable(A,C);
disp(bool);
```

**Output**

```text
0
```

---

## Test Case 4

```scilab
A = [1 0;
     0 -2];

E = eye(2,2);

C = [1 0];

bool = isdetectable(A,C,E);
disp(bool);
```

**Output**

```text
1
```

---

## Test Case 5

```scilab
A = [-0.5 0;
      0 -1];

C = [1 0];

bool = isdetectable(A,C,[],1e-6);
disp(bool);
```

**Output**

```text
1
```

---

## Test Case 6

```scilab
A = -2;

C = 1;

bool = isdetectable(A,C);
disp(bool);
```

**Output**

```text
1
```

---

## Test Case 7

```scilab
A = 2;

C = 0;

bool = isdetectable(A,C);
disp(bool);
```

**Output**

```text
0
```

---

## Test Case 8

```scilab
A = -2;

C = 0;

bool = isdetectable(A,C);
disp(bool);
```

**Output**

```text
1
```

---

## References

1. GNU Octave Control Package  
   https://github.com/gnu-octave/pkg-control

2. Original GNU Octave implementation of `isdetectable`  
   https://github.com/gnu-octave/pkg-control/blob/default/inst/isdetectable.m

3. SLICOT Reference Library  
   https://github.com/SLICOT/SLICOT-Reference
