/* 2026 Author: Pavan Kumar */


funcprot(0);

function display(obj)
    if argn(2) <> 1 then
        error(msprintf(_("%s: Wrong number of input arguments: 1 expected.\n"), "display"));
    end

    select typeof(obj)
    case "state-space"
        disp("  [state-space model]");
        disp("  a ="); disp(obj.A);
        disp("  b ="); disp(obj.B);
        disp("  c ="); disp(obj.C);
        disp("  d ="); disp(obj.D);
        if obj.dt == "c" then
            disp("  Continuous-time model.");
        else
            disp(msprintf("  Discrete-time model (dt = %s).", string(obj.dt)));
        end
    case "rational"
        disp("  [transfer function]");
        disp(obj);
    case "list"
        disp(msprintf("  [list with %d element(s)]", length(obj)));
        for i = 1:length(obj)
            disp(msprintf("  (%d):", i)); disp(obj(i));
        end
    case "st"
        fields = fieldnames(obj);
        for i = 1:length(fields)
            disp(msprintf("  .%s =", fields(i))); disp(obj(fields(i)));
        end
    else
        disp(obj);
    end
endfunction

// Test Cases
display(10);
display([1 2; 3 4]);
display("Hello");
display([]);
display([%t %f; %f %t]);

A = [-1,0;0,-2]; B = [1;1]; C = [1,0]; D = [0];
display(syslin("c", A, B, C, D));

s = poly(0, "s");
display(syslin("c", (s+2), (s+1)*(s+3)));

display([1+2*%i, 3-4*%i]);

try
    display(1, 2);
catch
    disp("Test Passed: wrong arg count caught");
end

try
    display();
catch
    disp("Test Passed: zero args caught");
end
