# repmat

Forms a block LTI system by repeating an input system vertically and horizontally — the Scilab equivalent of GNU Octave's `@lti/repmat`.

> `repmat(sys, 2, 3)` produces two vertical copies and three horizontal copies of `sys`.

---

## 📐 Calling Sequence

```scilab
sys = repmat(sys, m)
sys = repmat(sys, [m, n])
sys = repmat(sys, m, n)
```

## 📥 Parameters

| Argument | Description |
|---|---|
| `sys` | Input Scilab LTI system — transfer-function or state-space `syslin` object |
| `m` | Number of vertical repetitions (non-negative integer) |
| `n` | Number of horizontal repetitions (non-negative integer). If omitted, `n = m` |
| **returns** `sys` | Repeated block LTI system |

---

## 🔗 Dependencies

| File | Purpose |
|---|---|
| `__sys_prune__.sci` | Selects/reorders rows and columns of `sys` — required for index-based replication |

```scilab
exec("__sys_prune__.sci", -1);
exec("repmat.sci", -1);
```

> `is_real_scalar`, `is_real_vector`, and `__repmat_index__` are local helper functions bundled inside `repmat.sci`.

Executing `repmat.sci` defines the function **and** runs the test cases written directly below it.

---

## ✨ Examples

**1 — Tiling a SISO transfer function**

```scilab
s = poly(0, "s");
sys = syslin("c", s + 1, s + 2);
rsys = repmat(sys, 2, 3);
size(rsys)
```
```text
2.  3.
```

**2 — Tiling a MIMO state-space system**

```scilab
A = [-1, 0; 0, -2];
B = [1, 2; 3, 4];
C = [5, 6; 7, 8];
D = [9, 10; 11, 12];
sys = syslin("c", A, B, C, D);
rsys = repmat(sys, 2, 3);
size(rsys)
```
```text
4.  6.
```

> `A` is preserved · `B` repeated horizontally · `C` repeated vertically · `D` repeated both ways

**3 — Scalar shorthand**

```scilab
rsys = repmat(sys, 2);   // same as repmat(sys, 2, 2)
```

**4 — Vector form**

```scilab
rsys = repmat(sys, [3, 1]);   // 3 vertical, 1 horizontal
```

---

## ✅ Test Cases

| # | Test | Verifies |
|---|------|----------|
| 1 | `repmat(sys, m, n)` on SISO TF | Block size correct; every num/den entry matches original |
| 2 | `repmat(sys, m)` shorthand | Equal vertical/horizontal repetition |
| 3 | `repmat(sys, [m, n])` vector form | Correct unpacking of 2-element vector |
| 4 | MIMO state-space repetition | A preserved, B/C/D tiled correctly, X0 preserved |
| 5 | Invalid second argument | Error on malformed dimension input |
| 6 | Non-integer dimension | Error on non-integer m or n |
| 7 | Wrong number of arguments | Error when called with only `sys` |

**Output**
```text
Test Case 1: repmat(sys, m, n) passed
Test Case 2: repmat(sys, m) passed
Test Case 3: repmat(sys, [m, n]) passed
Test Case 4: MIMO state-space repetition passed
Test Case 5: invalid second argument detected
Test Case 6: non-integer dimension detected
Test Case 7: wrong number of input arguments detected
```

---

## 📁 Files

```text
repmat/
├── __sys_prune__.sci
├── repmat.sci
└── README.md
```

## ⚠️ Compatibility Notes

- `m` and `n` must be non-negative integers — non-integer or negative values raise an error.
- For state-space systems, initial state `X0` (if present) is preserved unchanged.
- State/input/output **names** are not preserved — Scilab `syslin` objects don't carry these fields.

---

## 👤 Author

- Original Octave author: **Lukas F. Reichlin**
- 2026 Scilab translation: **Simhadri Pavan Kumar**
