/*2025 Author: Akash S <akash.ktsn@gmail.com>*/
/*
Calling Sequence:
    [a, b, c, d, tsam] = ssdata (sys)
    [a, b, c, d, tsam] = ssdata (sys, tsam_in)
    [a, b, c, d, tsam] = ssdata (sys, tsam_in, e_in)
Parameters:
    a (Real matrix): State matrix (n-by-n).
    b (Real matrix): Input matrix (n-by-m).
    c (Real matrix): Measurement matrix (p-by-n).
    d (Real matrix): Feedthrough matrix (p-by-m).
    tsam (Real scalar): Sampling time in seconds. If sys is a continuous-time model, a zero is returned.
    sys (State-space): LTI system.
    tsam_in (Real scalar): Sampling time in seconds. If sys is a continuous-time model, a zero is returned.
    e_in (Real Matrix): Descriptor matrix
Description:
    Access state-space model data. Argument sys is not limited to state-space models. If sys is not a state-space model, it is converted automatically.
*/
function [a, b, c, d, tsam] = ssdata(sys, tsam_in, e_in)
    
    if typeof(sys) == 'rational' then
        sys = tf2ss(sys);
    elseif typeof(sys) <> 'state-space' then
        error("Input must be a syslin (state-space) system");
    end
    
    if sys.dt == 'd' & argn(2) < 2 & argn(1) > 4 then
        error("ssdata: tsam not provided for the discrete time system");
    end
    
    if argn(2) < 3 then
        e_in = [];
    end
    
    [a, b, c, d, e] = __sys_data__(sys);

    [a, b, c, d, e] = __dss2ss__(a, b, c, d, e_in);
    
    if sys.dt == 'c' then
        if argn(2) > 2 & tsam_in <> 0 then
            error("ssdata: tsam for a continuous time system should be zero");
        else
            tsam = 0;
        end
    elseif  argn(1) > 4
        tsam = tsam_in;
    end
    
endfunction

function [a, b, c, d, e] = __sys_data__(sys)
    a = sys.A;
    b = sys.B;
    c = sys.C;
    d = sys.D;
    e = [];
endfunction

function [a, b, c, d, e] = __dss2ss__(a, b, c, d, e)
    if isempty(e) then
        return;
    elseif rcond(e) < %eps then
        // Check whether regular state-space form is possible
        if (rank(e) + rank(a) < size(a, 1)) then
            error("ss: dss2ss: this descriptor system cannot be converted to regular state-space form");
        end
    end

    Sl = des2ss(a, b, c, d, e);
    a = Sl("A");
    b = Sl("B");
    c = Sl("C");
    d = Sl("D");
    e = [];
endfunction
