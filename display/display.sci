// 2026 Scilab Translation: Pavan kumar
// Original: Lukas F. Reichlin

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
    
    // Iterate through fieldnames to mimic Octave's internal cell processing
    for k = 1:size(name, "*")
        val = group(name(k));
        
       
        if isempty(val) then
            idx_string = "[]";
        else
            idx_string = "[" + strcat(string(matrix(val, 1, -1)), " ") + "]";
        end

        mprintf("%s group ''%s'' = %s\n", io, name(k), idx_string);
    end
endfunction

//  Test Cases 

// Test Case 1: Standard numeric indices
sys1 = struct("ingroup", struct("a", [1 2]), "outgroup", struct("b", 3), "name", "Sys1", "tsam", 0.5);
mprintf("\n--- Test Case 1 ---\n");
display(sys1);

// Test Case 2: Zero sampling time (Continuous)
sys2 = struct("ingroup", struct("a", 1), "outgroup", struct("b", 2), "name", "Sys2", "tsam", 0);
mprintf("\n--- Test Case 2 ---\n");
display(sys2);

// Test Case 3: Empty groups (No numeric data)
sys3 = struct("ingroup", struct(), "outgroup", struct(), "name", "Sys3", "tsam", -1);
mprintf("\n--- Test Case 3 ---\n");
display(sys3);

// Test Case 4: Column vector numeric indices
sys4 = struct("ingroup", struct("a", [1; 2]), "outgroup", struct("b", [3; 4]), "name", "Sys4", "tsam", 0.1);
mprintf("\n--- Test Case 4 ---\n");
display(sys4);

// Test Case 5: Multiple numeric indices in one group
sys5 = struct("ingroup", struct("a", [1 2 3 4]), "outgroup", struct("b", [5 6]), "name", "Sys5", "tsam", 1.0);
mprintf("\n--- Test Case 5 ---\n");
display(sys5);
