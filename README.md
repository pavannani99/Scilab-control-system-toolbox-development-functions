# Scilab-control-system-toolbox-development-functions
# zero

## Description

- The zero function computes zeros and gain of an LTI model.
- By default, invariant zeros are computed.
- Supports transfer function and state-space models.
- Different zero types can be computed:
  - invariant
  - system
  - transmission
  - input
  - output

## Calling Sequence

`[z,k,info]=zero(sys)`

`z=zero(sys,type)`

## Parameters

- `sys` - LTI model (transfer function or state-space model).

- `type` - String specifying type of zero computation.

  Supported values:
  - invariant
  - system
  - transmission
  - input
  - output

- `z` - Computed zeros.

- `k` - Gain of system.

- `info` - Structure containing additional information.

# Examples


## 1

      s=%s;

      sys=(s+2)/(s+1);

      [z,k,info]=zero(sys)

##

      z = -2

      k = 1



## 2

      s=%s;

      sys=(s^2+3*s+2)/(s+1);

      zero(sys)

##

      -2



## 3

      s=%s;

      sys=((s+1)^2)/(s+5);

      zero(sys)

##

      -1
      -1



## 4

      s=%s;

      sys=5/(s+1);

      zero(sys)

##

      []



## 5

      A=[0 1;-2 -3];

      B=[0;1];

      C=[1 2];

      D=0;

      sys=syslin("c",A,B,C,D);

      zero(sys)

##

      -0.5



## 6

      A=[0 1;-2 -3];

      B=[0;1];

      C=[1 2];

      D=0;

      sys=syslin("c",A,B,C,D);

      zero(sys,"transmission")

##

      -0.5



## 7

      zero(sys,"system")

##

      -0.5



## 8

      zero(sys,"input")

##

      []



## 9

      zero(sys,"output")

##

      []



## Notes

- The implementation follows behavior similar to Octave Control Toolbox.
- Transfer function and state-space models are supported.
- Scilab may simplify reducible transfer functions before computing zeros.
