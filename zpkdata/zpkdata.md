# zpkdata

## Description

`zpkdata` extracts the zero-pole-gain data from a given LTI system.

The function returns the zeros, poles, gain, and sampling time of the system. It works for transfer-function systems and also supports state-space systems by internally converting them into transfer-function form.

For SISO systems, the optional `"v"` flag can be used to return zeros and poles directly as vectors. Without the `"v"` flag, the zeros and poles are returned as lists, which is useful for MIMO systems.

## Calling Sequence

```scilab
[z, p, k, tsam] = zpkdata(sys)
[z, p, k, tsam] = zpkdata(sys, "v")
```

## Parameters

### Input Parameters

`sys`
LTI system whose zero-pole-gain data has to be extracted. The input can be a transfer-function system or a state-space system.

`"v"`
Optional flag. This flag is used only for SISO systems. When `"v"` is used, zeros and poles are returned as vectors instead of lists.

### Output Parameters

`z`
Zeros of the system. For default usage, this is returned as a list. For SISO systems with the `"v"` option, this is returned as a vector.

`p`
Poles of the system. For default usage, this is returned as a list. For SISO systems with the `"v"` option, this is returned as a vector.

`k`
Gain of the system. For MIMO systems, this is returned as a gain matrix.

`tsam`
Sampling time of the system. For continuous-time systems, it returns `"c"`. For discrete-time systems, it returns the sampling time value.

## Dependencies

This function uses the following Scilab built-in functions:

```scilab
syslin
ss2tf
roots
coeff
typeof
```

No external dependency file is required.

## Test Cases

### Test Case 1: Continuous-time SISO system with vector option

```scilab
s = poly(0, "s");

G1 = syslin("c", (s + 2) / ((s + 1) * (s + 3)));
[z1, p1, k1, t1] = zpkdata(G1, "v");

disp(z1);
disp(p1);
disp(k1);
disp(t1);
```

Expected result:

```text
Zero: -2
Poles: -1 and -3
Gain: 1
Sampling time: c
```

### Test Case 2: Continuous-time SISO system without vector option

```scilab
s = poly(0, "s");

G2 = syslin("c", 5 * (s + 4) / ((s + 2) * (s + 6)));
[z2, p2, k2, t2] = zpkdata(G2);

disp(z2);
disp(p2);
disp(k2);
disp(t2);
```

Expected result:

```text
Zero: -4
Poles: -2 and -6
Gain: 5
Sampling time: c
```

### Test Case 3: Discrete-time SISO system

```scilab
z = poly(0, "z");

G3 = syslin(0.1, (z + 0.5) / ((z - 0.2) * (z - 0.8)));
[z3, p3, k3, t3] = zpkdata(G3, "v");

disp(z3);
disp(p3);
disp(k3);
disp(t3);
```

Expected result:

```text
Zero: -0.5
Poles: 0.2 and 0.8
Gain: 1
Sampling time: 0.1
```

### Test Case 4: MIMO transfer-function system

```scilab
s = poly(0, "s");

G4 = syslin("c", [1/(s+1), 2/(s+2); 3/(s+3), 4/(s+4)]);
[z4, p4, k4, t4] = zpkdata(G4);

disp(z4);
disp(p4);
disp(k4);
disp(t4);
```

Expected result:

```text
Zeros and poles are returned as lists for each input-output channel.
Gain is returned as a 2-by-2 matrix.
Sampling time: c
```

### Test Case 5: Invalid input type

```scilab
try
    [z5, p5, k5, t5] = zpkdata([1 2; 3 4]);
catch
    mprintf("Error detected successfully.\n");
end
```

Expected result:

```text
The function should reject non-LTI input.
```

### Test Case 6: Wrong flag

```scilab
s = poly(0, "s");

G1 = syslin("c", (s + 2) / ((s + 1) * (s + 3)));

try
    [z6, p6, k6, t6] = zpkdata(G1, "wrong");
catch
    mprintf("Error detected successfully.\n");
end
```

Expected result:

```text
The function should reject an invalid second argument.
```

## Notes

The `"v"` option is valid only for SISO systems. For MIMO systems, zeros and poles are returned as lists.

This implementation follows the basic behavior of Octave-style `zpkdata` by extracting zeros, poles, gains, and sampling time from LTI systems in Scilab.
