# display

Implements the `display` function in Scilab with inputs and outputs matching Octave's `display` behavior.

---

## Syntax

```scilab
display(obj)
```

---

## Input

| Parameter | Type | Description |
|-----------|------|-------------|
| `obj` | any | Object to display |

---

## Supported Types

| Type | Scilab typeof | Example |
|------|--------------|---------|
| Scalar | `constant` | `display(10)` |
| Matrix | `constant` | `display([1 2; 3 4])` |
| String | `string` | `display("Hello")` |
| Empty matrix | `constant` | `display([])` |
| Boolean matrix | `boolean` | `display([%t %f])` |
| Complex matrix | `constant` | `display([1+2*%i])` |
| State-space system | `state-space` | `display(syslin("c", A, B, C, D))` |
| Transfer function | `rational` | `display(syslin("c", num, den))` |
| List | `list` | `display(list(1, "a"))` |
| Structure | `st` | `display(s)` |

---

## Examples

### Scalar
```scilab
display(10)
```
Output:
```
10
```

---

### Matrix
```scilab
display([1 2; 3 4])
```
Output:
```
   1   2
   3   4
```

---

### State-Space System
```scilab
A = [-1,0;0,-2]; B = [1;1]; C = [1,0]; D = [0];
display(syslin("c", A, B, C, D))
```
Output:
```
sys.a =
       x1  x2
   x1  -1   0
   x2   0  -2

sys.b =
       u1
   x1   1
   x2   1

sys.c =
       x1  x2
   y1   1   0

sys.d =
       u1
   y1   0

Continuous-time model.
```

---

### Transfer Function
```scilab
s = poly(0, "s");
display(syslin("c", (s+2), (s+1)*(s+3)))
```
Output:
```
Transfer function from input to output ...

            s + 2
y1:  ---------------
        s^2 + 4 s + 3
```

---

## Error Handling

```scilab
display()       // error: 1 argument expected
display(a, b)   // error: 1 argument expected
```

---

## Author

Pavan Kumar — FOSSEE Summer Fellowship 2026, IIT Bombay
