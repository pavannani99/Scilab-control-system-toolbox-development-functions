/* 2026 Author: Pavan Kumar */

/*
Description:
Display the contents of an object or variable.

```
  Note:
  Octave's display() function uses inputname() to display
  the caller variable name. Since Scilab does not provide
  an equivalent function, display() has been implemented
  using disp() to show the object contents.
```

Calling Sequence:
display(obj)

Parameters:
obj - object or variable to be displayed.

Dependencies:
disp
*/

function display(obj)
disp(obj);
endfunction
/*test cases
*/
x = 10;
display(x);

A = [1 2; 3 4];
display(A);

str = "Hello";
display(str);

E = [];
display(E);

B = [%t %f; %f %t];
display(B);

/*
Expected Output:

10.

11. 2.

12. 4.

"Hello"

[]

T F
F T
*/
