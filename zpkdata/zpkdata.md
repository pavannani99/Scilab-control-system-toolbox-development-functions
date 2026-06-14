# zpkdata

## Description

`zpkdata` returns the zero-pole-gain data of an LTI system.

It returns zeros, poles, gain, and sampling time.

This Scilab implementation follows the official Octave Control Package `zpkdata.m` source structure.

## Calling Sequence

[z, p, k, tsam] = zpkdata(sys)

[z, p, k, tsam] = zpkdata(sys, "v")

## Input Arguments

`sys`

LTI system or real-valued matrix.

A real-valued matrix is treated as a continuous-time static gain system.

`rtype`

Optional argument.

If `rtype` starts with `"v"` and the system is SISO, zeros and poles are returned directly as vectors.

## Output Arguments

`z`

Zeros of the system.

`p`

Poles of the system.

`k`

Gain matrix.

`tsam`

Sampling time.

For continuous-time systems, `tsam = 0`.

## Octave Source Structure Followed

The official Octave implementation follows this order:

1. Check whether `sys` is an LTI system.
2. If `sys` is not LTI, check whether it is a real matrix.
3. If it is a real matrix, treat it as a static gain system.
4. Obtain `num`, `den`, and `tsam`.
5. Remove leading zeros from `num`.
6. Remove leading zeros from `den`.
7. Compute `z` using `roots`.
8. Compute `p` using `roots`.
9. Compute `k` using `n(1)/d(1)`.
10. If `rtype` starts with `"v"` and the system is SISO, return `z` and `p` as vectors.

## Variable Names Preserved

The main Octave variable names are preserved:

`sys`

`rtype`

`num`

`den`

`tsam`

`z`

`p`

`k`

`n`

`d`

## Scilab Translation Notes

The Octave source uses cell arrays, `cellfun`, `tfdata`, `tf(sys)`, `isa(sys, "lti")`, and `issiso(sys)`.

These exact Octave features are not available in Scilab with the same syntax.

Therefore:

* Scilab lists are used in place of Octave cell arrays.
* Loops are used in place of Octave `cellfun`.
* `sys.num`, `sys.den`, and `sys.dt` are used in place of Octave `tfdata`.
* Real matrices are handled directly as static gain systems.
* SISO checking is done using numerator matrix dimensions.

## Dependencies

syslin

ss2tf

coeff

roots

poly

typeof

size

length

matrix

zeros

ones

imag

abs

max

convstr

part

argn

error

## Test Case File

Run the main file first:

exec("zpkdata.sci", -1);

Then run the test file:

exec("test_zpkdata.sce", -1);

## Files

zpkdata.sci

test_zpkdata.sce

README.md
