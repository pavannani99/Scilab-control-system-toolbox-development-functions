# damp

## Description:

* Calculate natural frequencies, damping ratios, and poles of a linear time-invariant (LTI) system.
* If no output is specified, displays an overview table containing poles, damping ratios, natural frequencies, and time constants.
* If `sys` is a discrete-time model, equivalent continuous-time poles are calculated.

## Calling Sequence:

* `damp(sys)`
* `[Wn, zeta] = damp(sys)`
* `[Wn, zeta, P] = damp(sys)`

## Parameters:

* `sys`      - LTI model (state-space, transfer function, etc.)
* `Wn`       - Natural frequencies of each pole (rad/s)
* `zeta`     - Damping ratios of each pole
* `P`        - Poles of the system

## Dependencies:

`syslin`, `spec`, `gsort`

## Examples

### 1

```scilab
A = [-1, 0, 0; 0, -2, 0; 0, 0, -3];
sys = syslin('c', A, ones(3, 1), eye(3, 3));
[Wn, zeta, P] = damp(sys)

```

```
Wn = 
   1.   2.   3.
zeta =
   1.   1.   1.
P =
  -1.  -2.  -3.

```

### 2

```scilab
H = syslin('c', [2, 5, 1], [1, 2, 3]);
[Wn, zeta, P] = damp(H)

```

```
Wn = 
   1.7320508   1.7320508
zeta =
   0.5773503   0.5773503
P =
  -1. + 1.4142136i  -1. - 1.4142136i

```

### 3

```scilab
H = syslin(0.01, [5, 3, 1], [1, 6, 4, 4]);
[Wn, zeta, P] = damp(H)

```

```
Wn = 
   193.49241   193.49241   356.52642
zeta =
   0.0774219   0.0774219  -0.4728135
P =
  -0.3019864 + 0.8062973i
  -0.3019864 - 0.8062973i
  -5.3960272 + 0.i

```
