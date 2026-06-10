# display

## Description:
- The `display` function displays the contents of an object or variable to the console.
- Used by Scilab/Octave whenever a statement does not end with a semicolon to suppress output.
- User-defined classes should overload `display` so that something useful is printed for a class object.

## Calling Sequence:
```
display(obj)
```

## Parameters:
- `obj` - Any Scilab variable to display. Supports: scalar, matrix (real/complex), string, boolean, polynomial, rational (TF), syslin (state-space), struct, list, empty matrix.

## Dependencies:
- `disp` - Scilab built-in

# Examples

## 1
```
display(10)
```
##
```
10.
```

## 2
```
display([1 2; 3 4])
```
##
```
1.   2.
3.   4.
```

## 3
```
display("Hello")
```
##
```
"Hello"
```

## 4
```
display([%t %f; %f %t])
```
##
```
T  F
F  T
```

## 5
```
A = [-1,0;0,-2]; B=[1;1]; C=[1,0]; D=[0];
sys = syslin("c", A, B, C, D);
display(sys)
```
##
```
  [state-space model]
  a =
  -1.   0.
   0.  -2.
  b =
   1.
   1.
  c =
   1.   0.
  d =
   0.
  Continuous-time model.
```

## 6
```
display([])
```
##
```
[]
```

## 7
```
display([1+2*%i, 3-4*%i])
```
##
```
1. + 2.i   3. - 4.i
```

## 8
```
try
    display(1, 2);
catch
    disp("Test Passed: error correctly thrown");
end
```
##
```
Test Passed: error correctly thrown
```
