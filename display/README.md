# display (LTI System)

## Description

* Formats and prints the properties of Linear Time-Invariant (LTI) system objects.
* Displays input group mappings, output group mappings, system names, and sampling times.
* Provides a human-readable summary of the system structure.

## Calling Sequence

* `display(sys)`

## Parameters

* `sys` - An LTI system structure containing the following fields:
* `ingroup` - Structure defining input group names and numeric indices.
* `outgroup` - Structure defining output group names and numeric indices.
* `name` - String identifier for the system.
* `tsam` - Sampling time ($0$ for continuous-time, $>0$ for discrete-time, $-1$ for unspecified).



## Examples

## 1

```scilab
sys1 = struct();
sys1.ingroup = struct("a", [1 2]);
sys1.outgroup = struct("b", 3);
sys1.name = "Sys1";
sys1.tsam = 0.5;
display(sys1);

```

```text
Input group 'a' = [1 2]
Output group 'b' = [3]
Name: Sys1
Sampling time: 0.5 s

```

## 2

```scilab
sys2 = struct();
sys2.ingroup = struct("a", 1);
sys2.outgroup = struct("b", 2);
sys2.name = "Sys2";
sys2.tsam = 0;
display(sys2);

```

```text
Input group 'a' = [1]
Output group 'b' = [2]
Name: Sys2

```

## 3

```scilab
sys3 = struct();
sys3.ingroup = struct();
sys3.outgroup = struct();
sys3.name = "Sys3";
sys3.tsam = -1;
display(sys3);

```

```text
Name: Sys3
Sampling time: unspecified

```

## 4

```scilab
sys4 = struct();
sys4.ingroup = struct("a", [1; 2]);
sys4.outgroup = struct("b", [3; 4]);
sys4.name = "Sys4";
sys4.tsam = 0.1;
display(sys4);

```

```text
Input group 'a' = [1 2]
Output group 'b' = [3 4]
Name: Sys4
Sampling time: 0.1 s

```

## 5

```scilab
sys5 = struct();
sys5.ingroup = struct("a", [1 2 3 4]);
sys5.outgroup = struct("b", [5 6]);
sys5.name = "Sys5";
sys5.tsam = 1.0;
display(sys5);

```

```text
Input group 'a' = [1 2 3 4]
Output group 'b' = [5 6]
Name: Sys5
Sampling time: 1 s

```

---

Are you ready to move on to documenting another function in your library, or do you need any final adjustments to this README file?
