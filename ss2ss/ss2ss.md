# ss2ss

## Description

`ss2ss` applies a similarity transformation to a state-space model.

This Scilab implementation follows the official Octave Control Package `@ss/ss2ss.m` source structure.

## Calling Sequence

SYS_T = ss2ss(SYS, T)

[A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T)

## Input Arguments

`SYS`

State-space system.

`T`

Transformation matrix.

`A`, `B`, `C`, `D`

State-space matrices.

## Output Arguments

`SYS_T`

Transformed state-space system.

`A_T`, `B_T`, `C_T`, `D_T`

Transformed state-space matrices.

## Octave Source Structure Followed

The Octave implementation follows this structure:

1. Check whether the number of input arguments is 2 or 5.
2. For two inputs, get `A`, `B`, `C`, and `D` from the state-space system.
3. Set `T = inv(second_in)`.
4. For five inputs, assign `A`, `B`, `C`, and `D` from the input matrices.
5. Set `T = inv(fifth_in)`.
6. Calculate:

A_T = inv(T) * A * T

B_T = inv(T) * B

C_T = C * T

D_T = D

7. For the two-input form, return the transformed state-space system.
8. For the five-input form, return the transformed matrices.

## Variable Names Preserved

The main Octave variable names are preserved:

`first_in`

`second_in`

`third_in`

`fourth_in`

`fifth_in`

`A`

`B`

`C`

`D`

`T`

`A_T`

`B_T`

`C_T`

`D_T`

`first_out`

`second_out`

`third_out`

`fourth_out`

## Scilab Translation Notes

The Octave source uses `ssdata(first_in)` and `ss(A_T, B_T, C_T, D_T)`.

In Scilab, these are translated as direct state-space field access:

A = first_in.A
B = first_in.B
C = first_in.C
D = first_in.D

and system creation using:

syslin("c", A_T, B_T, C_T, D_T)

## Test Cases

The test file includes:

1. State-space input form.
2. Matrix input-output form.
3. Re-transformation back to the original system.
4. Octave source-style 3x3 test.
5. Wrong number of inputs.
6. Too many output arguments for system input form.

## Dependencies

syslin

inv

spec

norm

argn

error

## Test Case File

Run the main file first:

exec("ss2ss.sci", -1);

Then run the test file:

exec("test_ss2ss.sce", -1);

## Files

ss2ss.sci

test_ss2ss.sce

README.md
