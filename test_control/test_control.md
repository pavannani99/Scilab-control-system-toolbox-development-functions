# test_control

## Description:
- The test_control function executes all available tests of the Control System Toolbox at once.
- In Octave, this is implemented as pkg test control which runs all tests belonging to the control package.
- The Scilab equivalent uses test_run() which is Scilab's built-in testing framework.

## Calling Sequence:
test_control()

## Parameters:
- None

## Dependencies:
- test_run - Scilab built-in testing framework

## Note:
- Requires the Control System Toolbox to be registered as a Scilab module.
- Implementation mirrors Octave's test_control which calls pkg test control.

# Examples

## 1
test_control()

##
Runs all available tests in the Control System Toolbox.

## 2
// Load the function first
exec('test_control.sce', -1);

// Then call it
test_control();

##
Executes all control toolbox tests via test_run("control").

## Reference:
- Octave source: https://github.com/gnu-octave/pkg-control/blob/main/inst/test_control.m
- Scilab test_run: https://help.scilab.org/test_run
