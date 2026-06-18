/* 2026 Author: Pavan Kumar */
/* sdata.sci
   Extracts A, B, C, D matrices from a Scilab state-space system.
*/

function [A, B, C, D] = sdata(sys)

    if typeof(sys) <> "state-space" & typeof(sys) <> "linear_system" then
        error("sdata: input argument must be a state-space system");
    end

    A = sys.A;
    B = sys.B;
    C = sys.C;
    D = sys.D;

endfunction
