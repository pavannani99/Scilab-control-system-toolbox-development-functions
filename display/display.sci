/* 2026 Author: Pavan Kumar */



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
