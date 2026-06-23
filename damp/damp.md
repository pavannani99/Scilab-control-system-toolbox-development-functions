# damp

Calculates poles, natural frequencies, damping ratios, and time constants for square matrices and Scilab LTI systems — the Scilab equivalent of GNU Octave's `damp.m` by Mark Bronsfeld.

> If no output is specified, displays an overview table with poles, magnitude (discrete-time only), damping ratios, natural frequencies, and time constants.

---

## 📐 Calling Sequence

```scilab
damp(sys)
Wn = damp(sys)
[Wn, zeta] = damp(sys)
[Wn, zeta, P] = damp(sys)
```

## 📥 Parameters

| Argument | Description |
|---|---|
| `sys` | LTI model (state-space or transfer-function `syslin` object) or a square numeric matrix |
| `Wn` | Natural frequencies of each pole, increasing order, in rad/s. For discrete-time models, contains the equivalent continuous-time frequencies. If sample time is unspecified, 1 second is assumed |
| `zeta` | Damping ratios, in the same order as `Wn` |
| `P` | Poles of `sys`, in the same order as `Wn` |

---

## 🧮 Algorithm

| Step | Formula |
|---|---|
| Pole | `s` (or `z` for discrete-time) via `pole`, sorted by increasing natural frequency |
| Equivalent continuous-time pole | `s = log(z) / sys.dt` (discrete-time only) |
| Magnitude | `mag = abs(z)` (discrete-time only) |
| Natural frequency | `Wn = abs(s)` |
| Damping ratio | `zeta = -cos(arg(s))` |
| Time constant | `tau = 1 / (Wn · zeta)` |

---

## 🔗 Dependencies

| File | Author | Source |
|---|---|---|
| `pole.sci` | Nikitha D | [pole.md](https://github.com/nikithad14/Scilab-control-system-toolbox-development-functions/blob/main/pole/pole.md) |
| `issiso.sci` | Nikitha D | [issiso.sci](https://github.com/nikithad14/Scilab-control-system-toolbox-development-functions/blob/main/issiso/issiso.sci) |
| `isct.sci` | Pavan Kumar | [isct.sci](https://github.com/pavannani99/Scilab-control-system-toolbox-development-functions/blob/main/isct.sci) |
| `isdt.sci` | Pavan Kumar | [isdt.sci](https://github.com/pavannani99/Scilab-control-system-toolbox-development-functions/blob/main/isdt.sci) |

> `pole.sci` depends on `issiso.sci` internally. Load all four before `damp.sci`.

```scilab
exec("issiso.sci", -1);
exec("pole.sci", -1);
exec("isct.sci", -1);
exec("isdt.sci", -1);
exec("damp.sci", -1);
```

Executing `damp.sci` defines the function **and** runs the test cases written at the bottom of the same file.

---

## ✅ Test Cases

| # | Test | Verifies |
|---|------|----------|
| 1 | Continuous-time state-space model | Poles, damping, Wn match diagonal A eigenvalues |
| 2 | Continuous-time transfer-function model | Complex conjugate pole pair, analytical Wn/zeta |
| 3 | Discrete-time, specified sample time | Equivalent continuous mapping via `log(z)/tsam` |
| 4 | Discrete-time, unspecified sample time | Defaults to 1 second per Octave convention |
| 5 | Numeric square state matrix | Works on plain matrices, not just LTI objects |
| 6 | No-output overview table | Table displays correctly with no return values |
| 7 | Invalid non-LTI, non-square argument | Error raised for malformed input |
| 8 | Wrong number of input arguments | Error raised when called with no arguments |

**Output**
```text
Test Case 1: Continuous-time state-space model passed
Test Case 2: Continuous-time transfer-function model passed
Test Case 3: Discrete-time model with specified sample time passed
Test Case 4: Unspecified discrete sample time passed
Test Case 5: Numeric square state matrix passed
Test Case 6: No-output overview table displayed successfully
Test Case 7: Invalid argument detected successfully
Test Case 8: Wrong number of input arguments detected successfully
```

---

## ⚠️ Compatibility Notes

- The accepted Scilab `pole.sci` can't process state-space `lss` objects directly — Scilab has no `issquare` overload for that type. `damp` works around this by computing poles via `spec(sys.A)` for state-space models and `pole(sys)` for transfer-function models and numeric matrices.
- Scilab has no string-repeat `repmat`; table spacing is built locally with `emptystr`.
- Scilab's `disp` would add quotes around a character matrix, so the overview table is printed row by row via `mprintf` to match Octave's unquoted output.

---

## 📁 Files

```text
damp/
├── damp.sci
└── README.md
```

## 👤 Authors

- Original `damp`: **Mark Bronsfeld**
- `pole`, `issiso`: **Nikitha D**
- `isct`, `isdt`, Scilab translation and integration: **Pavan Kumar**
