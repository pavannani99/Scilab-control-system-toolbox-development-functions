# display

## Description

`display` displays the contents of an input object on the console.

The function accepts one input argument and does not return any output argument. It is used to present the contents of an object or variable on screen.

This implementation follows the documented Octave-style behavior of `display(obj)`, where the input object is displayed and no value is returned.

## Calling Sequence

```scilab
display(obj)
```

## Parameters

### Input Parameter

`obj`
Object or variable to be displayed.

The input can be a numeric matrix, string, polynomial, transfer function, state-space system, list, structure, or any other valid Scilab object supported by `disp`.

### Output Parameter

This function does not return any output argument.

## Dependencies

This function uses the following Scilab built-in functions:

```scilab
argn
disp
error
```

No external dependency file is required.

## Test Cases

### Test Case 1: Numeric matrix

```scilab
A = [1 2; 3 4];
display(A);
```

Expected behavior:

```text
The numeric matrix is displayed.
```

### Test Case 2: String input

```scilab
str = "Scilab control toolbox";
display(str);
```

Expected behavior:

```text
The string is displayed.
```

### Test Case 3: Polynomial input

```scilab
s = poly(0, "s");
p = s^2 + 3*s + 2;
display(p);
```

Expected behavior:

```text
The polynomial is displayed.
```

### Test Case 4: Transfer function input

```scilab
s = poly(0, "s");
G = syslin("c", (s + 2)/(s^2 + 3*s + 2));
display(G);
```

Expected behavior:

```text
The transfer function is displayed.
```

### Test Case 5: Continuous-time state-space system

```scilab
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];
D = [0];

sysc = syslin("c", A, B, C, D);
display(sysc);
```

Expected behavior:

```text
The continuous-time state-space system is displayed.
```

### Test Case 6: Discrete-time state-space system

```scilab
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];
D = [0];

sysd = syslin(0.1, A, B, C, D);
display(sysd);
```

Expected behavior:

```text
The discrete-time state-space system is displayed.
```

### Test Case 7: List input

```scilab
L = list(1, "control", [1 2; 3 4]);
display(L);
```

Expected behavior:

```text
The list is displayed.
```

### Test Case 8: Structure input

```scilab
st.name = "system";
st.order = 2;
display(st);
```

Expected behavior:

```text
The structure is displayed.
```

### Test Case 9: Wrong number of inputs

```scilab
try
    display();
catch
    mprintf("Error detected successfully.\n");
end
```

Expected behavior:

```text
The function rejects an invalid number of input arguments.
```

### Test Case 10: Wrong number of outputs

```scilab
try
    out = display(A);
catch
    mprintf("Error detected successfully.\n");
end
```

Expected behavior:

```text
The function rejects output arguments because display does not return a value.
```

## Notes

The documented behavior of `display` is to accept one object and display its contents on screen. This implementation uses Scilab's native `disp` function to display the object content while validating the number of input and output arguments.
