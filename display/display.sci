funcprot(0);

function display(obj)

    [lhs, rhs] = argn(0);

    if rhs <> 1 then
        error("display: Wrong number of input arguments.");
    end

    if lhs > 0 then
        error("display: Wrong number of output arguments.");
    end

    disp(obj);

endfunction
