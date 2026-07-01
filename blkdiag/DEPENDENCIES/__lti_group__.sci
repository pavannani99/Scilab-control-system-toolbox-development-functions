// Copyright (C) 2026
// Scilab translation for FOSSEE Control Systems Toolbox
//
// Function: __lti_group__
// Octave source: @lti/__lti_group__.m
//
// Description:
//     Combines LTI sampling-time information for block diagonal grouping.
//     This Scilab version keeps the sampling-time compatibility behaviour
//     needed by blkdiag. Metadata fields such as input/output groups are
//     Octave object properties and are not present in Scilab syslin.

function dt = __lti_group__(sys1, sys2)

    dt1 = sys1.dt;
    dt2 = sys2.dt;

    if __blkdiag_same_dt__(dt1, dt2) then
        dt = dt1;
    elseif typeof(dt1) == "string" & dt1 == "d" & typeof(dt2) <> "string" then
        dt = dt2;
    elseif typeof(dt2) == "string" & dt2 == "d" & typeof(dt1) <> "string" then
        dt = dt1;
    else
        error("lti_group: systems must have identical sampling times");
    end

endfunction


function flag = __blkdiag_same_dt__(dt1, dt2)

    flag = %f;

    if typeof(dt1) <> typeof(dt2) then
        return;
    end

    if typeof(dt1) == "string" then
        flag = (dt1 == dt2);
    else
        flag = (abs(dt1 - dt2) <= %eps);
    end

endfunction
