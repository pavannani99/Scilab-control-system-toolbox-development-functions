/* 2026 Author: Pavan Kumar */
/* ss2ss.sci
   Applies a similarity transformation to a state-space model.
*/

function [first_out, second_out, third_out, fourth_out] = ss2ss(first_in, second_in, third_in, fourth_in, fifth_in)

    if argn(2) <> 2 & argn(2) <> 5 then
        error("ss2ss: wrong number of input arguments");
    end

    select argn(2)

    case 2 then
        [A, B, C, D] = sdata(first_in);
        T = inv(second_in);

    case 5 then
        A = first_in;
        B = second_in;
        C = third_in;
        D = fourth_in;
        T = inv(fifth_in);

    end

    A_T = inv(T) * A * T;
    B_T = inv(T) * B;
    C_T = C * T;
    D_T = D;

    select argn(2)

    case 2 then
        if argn(1) > 1 then
            error("Too many output arguments");
        end

        first_out = syslin("c", A_T, B_T, C_T, D_T);

    case 5 then
        if argn(1) > 4 then
            error("Too many output arguments");
        end

        first_out = A_T;
        second_out = B_T;
        third_out = C_T;
        fourth_out = D_T;

    end

endfunction
