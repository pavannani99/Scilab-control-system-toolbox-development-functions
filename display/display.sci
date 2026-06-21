/* Display routine for LTI objects. Called by its child classes. */

/* Author: Lukas Reichlin <lukas.reichlin@gmail.com> */
/* Created: September 2009 */
/* Version: 0.3 */
/* 2026 Scilab translation: ALLU RAM CHARAN */

function display(sys)

    if size(fieldnames(sys.ingroup), "*") > 0 then
        __disp_group__(sys.ingroup, "Input");
    end

    if size(fieldnames(sys.outgroup), "*") > 0 then
        __disp_group__(sys.outgroup, "Output");
    end

    if ~isempty(sys.name) then
        mprintf("Name: %s\n", sys.name);
    end

    if sys.tsam > 0 then
        mprintf("Sampling time: %g s\n", sys.tsam);
    elseif sys.tsam == -1 then
        mprintf("Sampling time: unspecified\n");
    end

endfunction


function __disp_group__(group, io)

    name = fieldnames(group);
    idx = cell(size(name, "*"), 1);

    for k = 1:size(name, "*")
        idx{k} = group(name(k));
    end

    for k = 1:size(name, "*")
        if isempty(idx{k}) then
            idx_string = "[]";
        else
            idx_string = "[" + strcat(string(matrix(idx{k}, 1, -1)), " ") + "]";
        end

        mprintf("%s group ''%s'' = %s\n", io, name(k), idx_string);
    end

endfunction


// Test Case 1: input/output groups, model name and positive sampling time
sys1 = struct();
sys1.ingroup = struct("control", [1 2], "disturbance", 3);
sys1.outgroup = struct("measured", 1, "estimated", [2 3]);
sys1.name = "Plant";
sys1.tsam = 0.1;

mprintf("\nTest Case 1\n");
display(sys1);

// Expected output:
// Input group 'control' = [1 2]
// Input group 'disturbance' = [3]
// Output group 'measured' = [1]
// Output group 'estimated' = [2 3]
// Name: Plant
// Sampling time: 0.1 s


// Test Case 2: continuous-time model
sys2 = struct();
sys2.ingroup = struct();
sys2.outgroup = struct();
sys2.name = "Continuous System";
sys2.tsam = 0;

mprintf("\nTest Case 2\n");
display(sys2);

// Expected output:
// Name: Continuous System
// No sampling-time line is displayed when tsam = 0.


// Test Case 3: unspecified sampling time and empty model name
sys3 = struct();
sys3.ingroup = struct("input", 1);
sys3.outgroup = struct("output", 1);
sys3.name = "";
sys3.tsam = -1;

mprintf("\nTest Case 3\n");
display(sys3);

// Expected output:
// Input group 'input' = [1]
// Output group 'output' = [1]
// Sampling time: unspecified


// Test Case 4: column-vector indices and an empty group
sys4 = struct();
sys4.ingroup = struct("actuators", [1; 2; 3], "unused", []);
sys4.outgroup = struct("states", [1; 2]);
sys4.name = "Discrete System";
sys4.tsam = 0.01;

mprintf("\nTest Case 4\n");
display(sys4);

// Expected output:
// Input group 'actuators' = [1 2 3]
// Input group 'unused' = []
// Output group 'states' = [1 2]
// Name: Discrete System
// Sampling time: 0.01 s
