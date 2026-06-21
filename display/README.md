# display_lti

## Description:

* Displays the common properties of an LTI object.
* Displays input groups, output groups, model name and sampling time.
* This is the Scilab translation of the GNU Octave Control package function `@lti/display.m`.

## Calling Sequence:

```scilab
display_lti(sys)
```

## Parameters:

* `sys` - LTI structure containing the following fields:

  * `ingroup` - Structure containing input-group names and input indices.
  * `outgroup` - Structure containing output-group names and output indices.
  * `name` - Name of the LTI model.
  * `tsam` - Sampling time of the model.

## Dependencies:

* No external dependency files are required.
* The local helper function `__disp_group__` is included in `display_lti.sci`.

# Examples

## 1

```scilab
sys = struct();
sys.ingroup = struct("control", [1 2], "disturbance", 3);
sys.outgroup = struct("measured", 1, "estimated", [2 3]);
sys.name = "Plant";
sys.tsam = 0.1;

display_lti(sys);
```

## Expected Output

```text
Input group 'control' = [1 2]
Input group 'disturbance' = [3]
Output group 'measured' = [1]
Output group 'estimated' = [2 3]
Name: Plant
Sampling time: 0.1 s
```

## 2

```scilab
sys = struct();
sys.ingroup = struct();
sys.outgroup = struct();
sys.name = "Continuous System";
sys.tsam = 0;

display_lti(sys);
```

## Expected Output

```text
Name: Continuous System
```

No sampling-time line is displayed when `tsam = 0`.

## 3

```scilab
sys = struct();
sys.ingroup = struct("input", 1);
sys.outgroup = struct("output", 1);
sys.name = "";
sys.tsam = -1;

display_lti(sys);
```

## Expected Output

```text
Input group 'input' = [1]
Output group 'output' = [1]
Sampling time: unspecified
```

## 4

```scilab
sys = struct();
sys.ingroup = struct("actuators", [1; 2; 3], "unused", []);
sys.outgroup = struct("states", [1; 2]);
sys.name = "Discrete System";
sys.tsam = 0.01;

display_lti(sys);
```

## Expected Output

```text
Input group 'actuators' = [1 2 3]
Input group 'unused' = []
Output group 'states' = [1 2]
Name: Discrete System
Sampling time: 0.01 s
```

## Execution:

Run the following command in Scilab:

```scilab
exec("display_lti.sci", -1);
```
