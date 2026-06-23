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

### Test 1: Continuous-time state-space model

**Input**
```scilab
A = [-1, 0, 0;
      0, -2, 0;
      0, 0, -3];
B = ones(3, 1);
C = eye(3, 3);
D = zeros(3, 1);
H = syslin("c", A, B, C, D);

[Wn, zeta, P] = damp(H);
```

**Output**
```text
Wn   = [1; 2; 3]
zeta = [1; 1; 1]
P    = [-1; -2; -3]
```

---

### Test 2: Continuous-time transfer-function model

**Input**
```scilab
s = poly(0, "s");
H = syslin("c", (2*s^2 + 5*s + 1) / (s^2 + 2*s + 3));

[Wn, zeta, P] = damp(H);
```

**Output**
```text
Wn   = [1.7321; 1.7321]
zeta = [0.5774; 0.5774]
P    = [-1.0000 + 1.4142i; -1.0000 - 1.4142i]
```

---

### Test 3: Discrete-time model with specified sample time

**Input**
```scilab
z = poly(0, "z");
H = syslin(0.01, (5*z^2 + 3*z + 1) / (z^3 + 6*z^2 + 4*z + 4));

[Wn, zeta, P] = damp(H);
```

**Output**
```text
Wn   = [193.4924; 193.4924; 356.5264]
zeta = [0.0774; 0.0774; -0.4728]
P    = [-0.3020 + 0.8063i; -0.3020 - 0.8063i; -5.3961 + 0.0000i]
```

---

### Test 4: Discrete-time model with unspecified sample time

**Input**
```scilab
z = poly(0, "z");
H = syslin("d", (z + 0.2) / ((z - 0.5) * (z - 0.25)));

[Wn, zeta, P] = damp(H);
```

**Output**
```text
P    = [0.5; 0.25]
Wn   = abs(log(P))      // sample time defaults to 1 second
zeta = -cos(arg(log(P)))
```

---

### Test 5: Numeric square state matrix

**Input**
```scilab
A = [-1, 0;
      0, -2];

[Wn, zeta, P] = damp(A);
```

**Output**
```text
Wn   = [1; 2]
zeta = [1; 1]
P    = [-1; -2]
```

---

### Test 6: No-output overview table

**Input**
```scilab
s = poly(0, "s");
H = syslin("c", (2*s^2 + 5*s + 1) / (s^2 + 2*s + 3));

damp(H);
```

**Output**
```text
   Pole              Damping       Frequency           Time Constant
                                    (rad/seconds)       (seconds)

   -1.00e+00 + 1.41e+00i   5.77e-01    1.73e+00         1.00e+00
   -1.00e+00 - 1.41e+00i   5.77e-01    1.73e+00         1.00e+00
```

---

### Test 7: Invalid non-LTI, non-square argument

**Input**
```scilab
damp([1, 2, 3]);
```

**Output**
```text
Error: damp: argument must be an LTI system
```

---

### Test 8: Wrong number of input arguments

**Input**
```scilab
damp();
```

**Output**
```text
Error: damp: wrong number of input arguments
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
