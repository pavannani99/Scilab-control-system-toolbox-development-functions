funcprot(0);

function [first_out, second_out, third_out, fourth_out] = ss2ss(first_in, second_in, third_in, fourth_in, fifth_in)

[nargout, nargin] = argn(0);

if nargin <> 2 & nargin <> 5 then
    error("ss2ss: wrong number of input arguments");
end

select nargin

case 2 then

    A = first_in.A;
    B = first_in.B;
    C = first_in.C;
    D = first_in.D;

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

select nargin

case 2 then

    if nargout > 1 then
        error("Too many output arguments");
    end

    first_out = syslin("c", A_T, B_T, C_T, D_T);

case 5 then

    if nargout > 4 then
        error("Too many output arguments");
    end

    first_out = A_T;
    second_out = B_T;
    third_out = C_T;
    fourth_out = D_T;

end


endfunction
