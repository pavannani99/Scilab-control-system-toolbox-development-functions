# `blkdiag` - Scilab Translation

## 1. Function Details

| Field | Details |
|---|---|
| Function name | `blkdiag` |
| Octave function name | `@lti/blkdiag` |
| MATLAB function name | `blkdiag` |
| Author | Pavan Kumar |
| Year | 2026 |
| Status | Done after local Scilab validation |

## 2. Description

`blkdiag` performs block-diagonal concatenation of LTI models. For state-space systems, it combines the state-space matrices as block-diagonal/interconnection matrices:

- `A` is formed as block diagonal of the individual `A` matrices.
- `B` is formed by placing each `B` matrix in the corresponding input block.
- `C` is formed by placing each `C` matrix in the corresponding output block.
- `D` is formed as block diagonal of the individual `D` matrices.

This Scilab implementation follows the Octave main function structure and uses dependency functions for the actual grouping logic.

## 3. Calling Sequence

```scilab
sys = blkdiag(sys1, sys2, ..., sysN)
```

## 4. Parameters

| Parameter | Description |
|---|---|
| `sys1, sys2, ..., sysN` | LTI systems created using `syslin()` or numeric static-gain matrices |
| `sys` | Resulting block-diagonal state-space system |

## 5. Files Included

```text
blkdiag/
├── __numeric_to_lti__.sci
├── __lti_group__.sci
├── __sys_group__.sci
├── blkdiag.sci
└── README.md
```

## 6. Dependencies

| Dependency file | Purpose |
|---|---|
| `__numeric_to_lti__.sci` | Converts numeric static-gain inputs into LTI systems and handles static-gain sampling-domain adjustment |
| `__lti_group__.sci` | Checks/combines sampling-time information for connected LTI systems |
| `__sys_group__.sci` | Performs the actual block-diagonal combination of two state-space systems |

## 7. Execution Order

Execute the dependency files before the main function:

```scilab
exec("__numeric_to_lti__.sci", -1);
exec("__lti_group__.sci", -1);
exec("__sys_group__.sci", -1);
exec("blkdiag.sci", -1);
```

## 8. Test Cases

The test cases are included inside the main file `blkdiag.sci` as the function:

```scilab
blkdiag_test();
```

Run:

```scilab
exec("__numeric_to_lti__.sci", -1);
exec("__lti_group__.sci", -1);
exec("__sys_group__.sci", -1);
exec("blkdiag.sci", -1);
blkdiag_test();
```

## 9. Test Coverage

| Test case | What is checked |
|---|---|
| Test Case 1 | Block diagonal concatenation of two continuous-time state-space systems |
| Test Case 2 | Block diagonal concatenation of three continuous-time state-space systems |
| Test Case 3 | Single input argument behaviour |
| Test Case 4 | Numeric static-gain input converted into an LTI block |
| Test Case 5 | Discrete-time systems with identical sampling domain |
| Test Case 6 | Error handling for mismatched continuous/discrete sampling domains |
| Test Case 7 | Error handling for invalid non-numeric, non-LTI input |

## 10. Octave Source References

| File | Official GNU Octave Control source |
|---|---|
| Main function | `https://github.com/gnu-octave/pkg-control/blob/main/inst/%40lti/blkdiag.m` |
| Main dependency | `https://github.com/gnu-octave/pkg-control/blob/main/inst/%40ss/__sys_group__.m` |
| Numeric conversion dependency | `https://github.com/gnu-octave/pkg-control/blob/main/inst/%40lti/__numeric_to_lti__.m` |
| LTI grouping dependency | `https://github.com/gnu-octave/pkg-control/blob/main/inst/%40lti/__lti_group__.m` |

## 11. Implementation Notes

- The main `blkdiag.sci` file is kept as a line-by-line Scilab translation of the Octave main wrapper as much as Scilab syntax allows.
- Octave uses object fields such as `.a`, `.b`, `.c`, `.d`, `.e`, `.lti`, and `.stname`.
- Scilab `syslin` uses `.A`, `.B`, `.C`, `.D`, and `.dt`.
- Therefore, this implementation matches the state-space matrix behaviour for regular Scilab systems.
- Octave metadata fields such as input/output names, groups, state names, and descriptor matrix `E` are not directly reproduced because they are not stored in the same way in Scilab `syslin` objects.

## 12. Expected Result

After running `blkdiag_test()`, all test cases should print passed messages and end with:

```text
All blkdiag test cases completed.
```
