mprintf("Running test_control test case...\n\n");

try
    exec("test_control.sce", -1);
    mprintf("test_control executed successfully.\n");
catch
    mprintf("test_control execution failed.\n");
end

mprintf("\nAll test_control test cases executed.\n");
