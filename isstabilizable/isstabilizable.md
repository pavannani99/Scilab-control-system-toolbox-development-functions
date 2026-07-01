# isstabilizable

## Description

Determines whether a continuous time, discrete time, or descriptor state space system is **stabilizable**.

A system is stabilizable if every unstable mode is controllable. Equivalently, all uncontrollable modes must be stable. The function returns a logical value indicating whether the supplied system satisfies the stabilizability condition.

---

## Calling Sequence

```text
bool = isstabilizable(sys)

bool = isstabilizable(sys, tol)

bool = isstabilizable(A, B)

bool = isstabilizable(A, B, E)

bool = isstabilizable(A, B, [], tol)

bool = isstabilizable(A, B, E, tol)

bool = isstabilizable(A, B, [], [], dflg)

bool = isstabilizable(A, B, E, [], dflg)

bool = isstabilizable(A, B, [], tol, dflg)

bool = isstabilizable(A, B, E, tol, dflg)
```

---

## Parameters

* **sys** : Continuous time, discrete time, or descriptor state space model.
* **A** : State matrix.
* **B** : Input matrix.
* **E** : Descriptor matrix. If omitted or empty (`[]`), an identity matrix is assumed.
* **tol** : Optional stability tolerance. Default value is `0`.
* **dflg**

  * `0` : Continuous time system (default).
  * `1` : Discrete time system.
* **bool** : Logical output indicating whether the system is stabilizable.

---

## Dependencies

* `__is_stable__`
* `__sl_ab01od__`
* `__sl_tg01hd__`
* `isct` (used only when an LTI system is supplied)

---

# Test Cases

## Test Case 1: Controllable Continuous Time System

```scilab
A = [-1 0;
      0 2];

B = [1;
     1];

bool = isstabilizable(A,B);
disp(bool);
```

**Output**

```text
T
```

---

## Test Case 2: Uncontrollable Stable Mode

```scilab
A = [-2 0;
      0 -3];

B = [1;
     0];

bool = isstabilizable(A,B);
disp(bool);
```

**Output**

```text
T
```

---

## Test Case 3: Uncontrollable Unstable Mode

```scilab
A = [2 0;
     0 -1];

B = [0;
     1];

bool = isstabilizable(A,B);
disp(bool);
```

**Output**

```text
F
```

---

## Test Case 4: Descriptor State Space System

```scilab
A = [1 0;
     0 -2];

E = eye(2,2);

B = [1;
     0];

bool = isstabilizable(A,B,E);
disp(bool);
```

**Output**

```text
T
```

---

## Test Case 5: Explicit Stability Tolerance

```scilab
A = [-0.5 0;
      0 -1];

B = [1;
     0];

bool = isstabilizable(A,B,[],1e-6);
disp(bool);
```

**Output**

```text
T
```

---

## Test Case 6: SISO System

```scilab
A = -2;

B = 1;

bool = isstabilizable(A,B);
disp(bool);
```

**Output**

```text
T
```

---

## Test Case 7: Zero Input Matrix with Unstable State

```scilab
A = 2;

B = 0;

bool = isstabilizable(A,B);
disp(bool);
```

**Output**

```text
F
```

---

## Test Case 8: Zero Input Matrix with Stable State

```scilab
A = -2;

B = 0;

bool = isstabilizable(A,B);
disp(bool);
```

**Output**

```text
T
```

---

## Authors

**Original GNU Octave Implementation**

Lukas F. Reichlin

**Scilab Translation**

Simhadri Pavan Kumar

---

## License

This function is a Scilab translation of the GNU Octave Control Package implementation of `isstabilizable`, which is distributed under the GNU General Public License (GPL). The translated implementation follows the same licensing terms.

