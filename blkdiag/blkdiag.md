# blkdiag

## Description

`blkdiag` creates block-diagonal concatenation of LTI state-space models.

For multiple input systems,

```text
sys = blkdiag(sys1, sys2, ..., sysN)
```

the output system is formed by placing the individual system matrices along the block diagonal.

For two systems, the resulting matrices are:

```text
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

```text
sys = blkdiag(sys1, sys2)
sys = blkdiag(sys1, sys2, ..., sysN)
```

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

The Octave Control Package source uses the following main structure:

```text
function sys = blkdiag (varargin)

  sys = varargin{1};

  for k = 2 : nargin
    sys = __sys_group__ (sys, varargin{k});
  endfor

endfunction
```

The Scilab implementation follows the same main structure:

```text
function sys = blkdiag(varargin)

sys = varargin(1);

for k = 2:argn(2)
sys = __sys_group__(sys, varargin(k));
end

endfunction
```

The main syntax replacements are:

```text
varargin{1}   -> varargin(1)
nargin        -> argn(2)
endfor        -> end
```

Octave uses the internal function `__sys_group__` to group two LTI systems. Since this internal Octave function is not directly available in Scilab, an equivalent local `__sys_group__` function is implemented for state-space systems.

The local `__sys_group__` function constructs the block-diagonal `A`, `B`, `C`, and `D` matrices and creates the resulting system using `syslin`.

## Test Cases

The implementation was tested for:

1. Two continuous-time state-space systems
2. Three continuous-time state-space systems
3. Two discrete-time systems with the same sampling time
4. Single system input
5. Different sampling time error handling

## Example 1

```text
sys1 = syslin("c", [-1], [1], [2], [0]);
sys2 = syslin("c", [-2], [3], [4], [5]);

sys = blkdiag(sys1, sys2);
```

Expected output:

```text
A =
-1   0
 0  -2

B =
1   0
0   3

C =
2   0
0   4

D =
0   0
0   5
```

## Example 2

```text
sys1 = syslin("c", [-1], [1], [1], [0]);
sys2 = syslin("c", [-2], [2], [2], [0]);
sys3 = syslin("c", [-3], [3], [3], [0]);

sys = blkdiag(sys1, sys2, sys3);
```

Expected output:

```text
A =
-1   0   0
 0  -2   0
 0   0  -3

B =
1   0   0
0   2   0
0   0   3

C =
1   0   0
0   2   0
0   0   3

D =
0   0   0
0   0   0
0   0   0
```

## Output Verification

The Scilab output was compared with the Octave Control Package output for the same test cases. The block-diagonal `A`, `B`, `C`, and `D` matrices matched for continuous-time, discrete-time, and single-system cases.
