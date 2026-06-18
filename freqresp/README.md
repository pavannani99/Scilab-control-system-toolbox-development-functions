# freqresp

## Description

`freqresp` evaluates the frequency response of a continuous-time state-space system at the given frequency values.

For a continuous-time state-space system,

```text
x_dot = A*x + B*u
y     = C*x + D*u
```

the frequency response is computed as:

```text
H(:,:,k) = C * inv(%i*w(k)*I - A) * B + D
```

For a system with `m` inputs and `p` outputs, the output array `H` has dimensions `[p, m, length(w)]`. The frequency response at `w(k)` is stored in `H(:,:,k)`.

## Calling Sequence

```text
H = freqresp(sys, w)
```

## Parameters

* **sys** - Input continuous-time state-space system.
* **w** - Real-valued vector of frequency values.
* **H** - Frequency response array. For a system with `p` outputs and `m` inputs, `H` has size `[p, m, length(w)]`.

## Dependencies

* **__freqresp__.sci** - Computes the frequency response of the state-space system at the given frequency values.

The dependency file must be executed before the main function while running the unit tests.

```scilab
exec("__freqresp__.sci", -1);
exec("freqresp.sci", -1);
```

Built-in Scilab functions such as `argn`, `type`, `isreal`, `size`, `length`, `matrix`, `abcd`, `eye`, `inv`, `zeros`, `norm`, and `disp` are not listed as dependency files.

---

## Examples

## 1

Frequency response of a first-order SISO system:

```scilab
A = -1;
B = 1;
C = 1;
D = 0;
w = [0 1 2];

sys = syslin("c", A, B, C, D);
H = freqresp(sys, w);

disp(H);
```

Expected result:

```text
H(:,:,1) = 1
H(:,:,2) = 0.5 - 0.5i
H(:,:,3) = 0.2 - 0.4i
```

## 2

System with direct feedthrough term:

```scilab
A = -2;
B = 1;
C = 3;
D = 2;
w = 0;

sys = syslin("c", A, B, C, D);
H = freqresp(sys, w);

disp(H(:,:,1));
```

Expected output:

```text
3.5
```

## 3

MIMO system frequency response at zero frequency:

```scilab
A = -1;
B = [1 2];
C = [3; 4];
D = [0 0; 0 0];
w = 0;

sys = syslin("c", A, B, C, D);
H = freqresp(sys, w);

disp(H(:,:,1));
```

Expected output:

```text
3  6
4  8
```

---

## Test Cases

The following test cases are included in `freqresp.sci`:

1. SISO first-order system frequency response.
2. System with direct feedthrough term.
3. MIMO system response at zero frequency.
4. Column vector frequency input.
5. Invalid complex frequency input.
6. Wrong number of input arguments.

## Test Results

Expected successful test output includes both pass messages and displayed output values.

```text
Test Case 1: SISO frequency response passed
Test Case 1: Frequency response values
w = 0
   1.
w = 1
   0.5 - 0.5i
w = 2
   0.2 - 0.4i

Test Case 2: Direct feedthrough response passed
Test Case 2: Frequency response value
   3.5

Test Case 3: MIMO frequency response passed
Test Case 3: Frequency response matrix
   3.   6.
   4.   8.

Test Case 4: Column frequency vector passed
Test Case 4: Size of output array H
   1.   1.   3.

Test Case 5: Invalid frequency input detected successfully
Test Case 6: Wrong number of input arguments detected successfully
```

---

## Source Translation Notes

This function follows the source-structure translation of GNU Octave's `freqresp` function.

The Octave source validates the number of input arguments, checks that the second input is a real-valued frequency vector, and then calls the internal helper function:

```text
H = __freqresp__(sys, w)
```

The same wrapper structure is preserved in the Scilab translation.

The helper file `__freqresp__.sci` computes the frequency response using the continuous-time state-space formula:

```text
H(:,:,k) = C * inv(%i*w(k)*I - A) * B + D
```

## Compatibility Notes

* This implementation is intended for continuous-time Scilab state-space systems created using `syslin("c", A, B, C, D)`.
* The frequency vector `w` must be real-valued and must be either a row vector or a column vector.
* The output `H` is a three-dimensional array where `H(:,:,k)` gives the response at frequency `w(k)`.
