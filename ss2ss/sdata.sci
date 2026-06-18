/* 2026 Author: Pavan Kumar */
/* sdata.sci
   Extracts A, B, C, D matrices from a Scilab linear system.
*/

function [A, B, C, D] = sdata(sys)

    [A, B, C, D] = abcd(sys);

endfunction
