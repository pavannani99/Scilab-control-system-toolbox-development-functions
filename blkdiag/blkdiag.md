# blkdiag

## Description

* Creates block-diagonal concatenation of LTI state-space models.
* Combines two or more state-space systems into one larger state-space system.
* The function follows the same main structure as the Octave `blkdiag` function.

For two systems,

```
sys = blkdiag(sys1, sys2)
```

the resulting system matrices are formed as:

```
A = [A1  0
     0   A2]

B = [B1  0
     0   B2]

C = [C1  0
     0   C2]

D = [D1  0
     0   D2]
```

## Calling Sequence

* `sys = blkdiag(sys1, sys2)`
* `sys = blkdiag(sys1, sys2, ..., sysN)`

## Parameters

* `sys1, sys2, sysN` - Input state-space systems
* `sys` - Block-diagonal state-space system

## Dependencies

* `syslin`
* `zeros`
* `size`
* `norm`
* `disp`

## Source Translation Notes

The Octave source structure is:

```
function sys = blkdiag (varargin)

  sys = varargin{1};

  for k = 2 : nargin
    sys = __sys_group__ (sys, varargin{k});
  endfor

endfunction
```

The Scilab implementation follows the same structure:

```
function sys = blkdiag(varargin)

  sys = varargin(1);

  for k = 2:argn(2)
    sys = __sys_group__(sys, varargin(k));
  end

endfunction
```

The main syntax changes are:

* `varargin{1}` is replaced by `varargin(1)`
* `nargin` is replaced by `argn(2)`
* `endfor` is replaced by `end`
* Octave internal function `__sys_group__` is implemented locally in Scilab

Since Octave's internal `__sys_group__` function is not directly available in Scilab, the same block-diagonal grouping operation is implemented by directly constructing the `A`, `B`, `C`, and `D` matrices.

## Examples

## 1

```
sys1 = syslin("c", [-1], [1], [2], [0]);
sys2 = syslin("c", [-2], [3], [4], [5]);

sys = blkdiag(sys1, sys2);

disp(sys.A);
disp(sys.B);
disp(sys.C);
disp(sys.D);
```

Output:

```
sys.A =
  -1.   0.
   0.  -2.

sys.B =
   1.   0.
   0.   3.

sys.C =
   2.   0.
   0.   4.

sys.D =
   0.   0.
   0.   5.
```

## 2

```
sys1 = syslin("c", [-1], [1], [1], [0]);
sys2 = syslin("c", [-2], [2], [2], [0]);
sys3 = syslin("c", [-3], [3], [3], [0]);

sys = blkdiag(sys1, sys2, sys3);

disp(sys.A);
disp(sys.B);
disp(sys.C);
disp(sys.D);
```

Output:

```
sys.A =
  -1.   0.   0.
   0.  -2.   0.
   0.   0.  -3.

sys.B =
   1.   0.   0.
   0.   2.   0.
   0.   0.   3.

sys.C =
   1.   0.   0.
   0.   2.   0.
   0.   0.   3.

sys.D =
   0.   0.   0.
   0.   0.   0.
   0.   0.   0.
```

## 3

```
sys1 = syslin(0.1, [0.5], [1], [1], [0]);
sys2 = syslin(0.1, [0.2], [2], [3], [4]);

sys = blkdiag(sys1, sys2);

disp(sys.A);
disp(sys.B);
disp(sys.C);
disp(sys.D);
```

Output:

```
sys.A =
   0.5   0.
   0.    0.2

sys.B =
   1.   0.
   0.   2.

sys.C =
   1.   0.
   0.   3.

sys.D =
   0.   0.
   0.   4.
```

## 4

```
sys1 = syslin("c", [-5], [2], [3], [1]);

sys = blkdiag(sys1);

disp(sys.A);
disp(sys.B);
disp(sys.C);
disp(sys.D);
```

Output:

```
sys.A =
  -5.

sys.B =
   2.

sys.C =
   3.

sys.D =
   1.
```

## 5

```
try
    sys1 = syslin(0.1, [0.5], [1], [1], [0]);
    sys2 = syslin(0.2, [0.3], [1], [1], [0]);
    sys = blkdiag(sys1, sys2);
catch
    disp("Different sampling time detected successfully");
end
```

Output:

```
Different sampling time detected successfully
```
