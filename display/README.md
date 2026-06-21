# display_lti

## Description

`display_lti` is the Scilab translation of GNU Octave Control package function `@lti/display.m`.

It displays the common LTI properties handled by the original function:

- input groups,
- output groups,
- model name,
- sampling time.

The original source order, branch order, variable names and local helper structure are retained as closely as Scilab syntax allows.

## Calling Sequence

```scilab
display_lti(sys)
```

## Parameter

- `sys`: LTI-style structure containing:
  - `ingroup`: structure whose field names are input-group names and whose values are input indices;
  - `outgroup`: structure whose field names are output-group names and whose values are output indices;
  - `name`: model-name string, which may be empty;
  - `tsam`: sampling time.

Sampling-time behaviour:

- `tsam > 0`: prints the sampling time in seconds;
- `tsam == 0`: prints no sampling-time line;
- `tsam == -1`: prints `Sampling time: unspecified`.

## Dependencies

No external dependency files are required.

The local helper function `__disp_group__` is included in `display_lti.sci`.

Scilab built-ins used:

- `fieldnames`
- `size`
- `isempty`
- `cell`
- `matrix`
- `string`
- `strcat`
- `mprintf`

## Files

```text
display_lti/
├── display_lti.sci
└── README.md
```

## Execution

Keep both files in the same folder and run:

```scilab
exec("display_lti.sci", -1);
```

The main function, local helper and test cases are contained in the same `.sci` file.

## Source Translation Mapping

| GNU Octave source | Scilab translation |
|---|---|
| `numfields(group)` | `size(fieldnames(group), "*")` |
| `fieldnames(group)` | `fieldnames(group)` |
| `struct2cell(group)` | a Scilab cell filled by dynamic field extraction |
| `cellfun(...)` | a `for` loop over the same names and values |
| `idx(:).'` | `matrix(idx, 1, -1)` |
| `mat2str(...)` | `string` + `strcat` with brackets |
| `printf` / `disp(sprintf(...))` | `mprintf` |

The `struct2cell + cellfun` statement is the only part that must expand into loops because Scilab does not provide the same Octave expression. No source branch or displayed property is omitted.

## Test Cases

### Test Case 1 — Groups, name and positive sampling time

```scilab
sys1 = struct();
sys1.ingroup = struct("control", [1 2], "disturbance", 3);
sys1.outgroup = struct("measured", 1, "estimated", [2 3]);
sys1.name = "Plant";
sys1.tsam = 0.1;
display_lti(sys1);
```

Expected output:

```text
Input group 'control' = [1 2]
Input group 'disturbance' = [3]
Output group 'measured' = [1]
Output group 'estimated' = [2 3]
Name: Plant
Sampling time: 0.1 s
```

### Test Case 2 — Continuous-time model

```scilab
sys2 = struct();
sys2.ingroup = struct();
sys2.outgroup = struct();
sys2.name = "Continuous System";
sys2.tsam = 0;
display_lti(sys2);
```

Expected output:

```text
Name: Continuous System
```

### Test Case 3 — Unspecified sampling time

```scilab
sys3 = struct();
sys3.ingroup = struct("input", 1);
sys3.outgroup = struct("output", 1);
sys3.name = "";
sys3.tsam = -1;
display_lti(sys3);
```

Expected output:

```text
Input group 'input' = [1]
Output group 'output' = [1]
Sampling time: unspecified
```

### Test Case 4 — Column-vector and empty group indices

```scilab
sys4 = struct();
sys4.ingroup = struct("actuators", [1; 2; 3], "unused", []);
sys4.outgroup = struct("states", [1; 2]);
sys4.name = "Discrete System";
sys4.tsam = 0.01;
display_lti(sys4);
```

Expected output:

```text
Input group 'actuators' = [1 2 3]
Input group 'unused' = []
Output group 'states' = [1 2]
Name: Discrete System
Sampling time: 0.01 s
```

## Behaviour Coverage

The tests cover every branch of the translated source:

1. non-empty `ingroup`;
2. non-empty `outgroup`;
3. non-empty and empty `name`;
4. positive `tsam`;
5. continuous-time `tsam = 0`;
6. unspecified `tsam = -1`;
7. scalar, row-vector, column-vector and empty group indices.

## Validation Note

The earlier version of the same function and helper logic was executed successfully in Scilab by the user. This final version keeps that logic and changes the name and sampling-time lines to `mprintf` so that the output matches Octave without Scilab string quotation marks.
