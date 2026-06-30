function [a, b, c, d, e] = __dss2ss__(a, b, c, d, e)
    // Logic for descriptor to standard form
    if ~isempty(e) then
        if rcond(e) < 1e-12 then
            error("dss:improper", "Descriptor system cannot be converted to regular form");
        end
        a = e \ a;
        b = e \ b;
        e = [];
    end
endfunction
