# freqresp

## Description

- Evaluate frequency response of an LTI system at given frequencies.
- For a system with `p` outputs and `m` inputs, returns a 3D complex array `H` of size `[p, m, length(w)]`.
- `H(:,:,k)` gives the frequency response at frequency `w(k)`.
- Supports both continuous and discrete-time systems.
- Accepts `state-space` or `rational` (tf) system objects.

## Calling Sequence

- `H = freqresp(sys, w)`
- `H = freqresp(sys, [])` (returns empty array with correct dimensions)

## Parameters

- `sys` - LTI system (`state-space` or `rational`).
- `w`   - Real-valued vector of frequencies (rad/s). Can be empty.
- `H`   - Complex frequency response array of size `[p, m, length(w)]`.

## Dependencies
- `__freqresp__.sci` (internal)

## Examples

## 1

```scilab
s = poly(0,'s');
G = syslin('c', 1/(s+1));
w = [0, 1, 10];
H = freqresp(G, w);
disp("Test Case 1 (SISO):");
disp("w =", w);
disp("H =", H);
```

## 2

```scilab
s = poly(0,'s');
G = syslin('c', 1/(s^2 + 0.2*s + 1));
w = [0.1, 1];
H = freqresp(G, w);
disp("Test Case 2:");
disp("H =", H);
```

## 3

```scilab
s = poly(0,'s');
G = syslin('c', [1; 2*s]/(s+1));
H = freqresp(G, [0 1]);
disp("Test Case 3 (MIMO 2x1):");
disp("H(:,:,1) =", H(:,:,1));
```

## 4

```scilab
G = syslin(0.5, 0.8/(1-0.5*%z^-1));
H = freqresp(G, [0 %pi]);
disp("Test Case 4 (Discrete):");
disp("H =", H);
```

## 5

```scilab
s = poly(0,'s');
G = syslin('c', 1/(s+1));
H = freqresp(G, 5);
disp("Test Case 5 (Scalar frequency):");
disp("H =", H);
```

**Author**: Pavan Kumar  
**Status**: Completed - Octave Compatible
