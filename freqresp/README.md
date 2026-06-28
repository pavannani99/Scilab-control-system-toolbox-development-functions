# freqresp - Scilab Translation

## Function name

`freqresp`

## Octave source name

`@lti/freqresp`

## MATLAB function name

`freqresp`

## Description

This function evaluates the frequency response of an LTI system at the given angular frequencies.
For a system with `p` outputs and `m` inputs, the output `H` has dimensions:

```text
[p, m, length(w)]
```

The response at frequency `w(k)` is stored in:

```text
H(:, :, k)
```

## Files

```text
freqresp/
├── __freqresp__.sci
├── freqresp.sci
└── README.md
```

## Dependencies

| File | Purpose |
|---|---|
| `__freqresp__.sci` | Internal helper that evaluates the response using the state-space frequency-response formula. |

## Execution order

```scilab
exec("__freqresp__.sci", -1);
exec("freqresp.sci", -1);
```

## Run tests

The test cases are included inside the main file `freqresp.sci`.

```scilab
freqresp_test();
```

## Implemented behavior

- Continuous-time state-space systems
- Discrete-time state-space systems
- Rational transfer-function input using `tf2ss`
- Real scalar, row-vector, and column-vector frequency input
- SISO and MIMO output arrays
- Error handling for wrong number of arguments
- Error handling for complex/non-real frequency vectors

## Test cases included

1. Continuous-time SISO state-space response.
2. Continuous-time MIMO state-space response.
3. Discrete-time state-space response with implicit unit sample time.
4. Column-vector frequency input.
5. Scalar frequency input.
6. Complex frequency-vector error case.
7. Wrong-number-of-arguments error case.

## Notes

The main Octave `@lti/freqresp` file validates the input arguments and calls the internal helper `__freqresp__`.
This Scilab translation keeps the same source structure using `freqresp.sci` and `__freqresp__.sci`.

The Octave package has separate class-specific `__freqresp__` implementations for `ss`, `tf`, and `frd` models. This Scilab version focuses on regular Scilab state-space systems and rational transfer functions that can be converted with `tf2ss`.

Descriptor-system `E` matrix support, prescaling, and FRD model support are not implemented in this version.
