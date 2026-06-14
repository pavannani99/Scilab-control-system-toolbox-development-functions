clc;
clear;

this_file_path = get_absolute_file_path("display.sce");
exec(this_file_path + "display.sci", -1);

mprintf("Running display checks...\n\n");

mprintf("Numeric matrix:\n");
A = [1 2; 3 4];
display(A);

mprintf("\nString:\n");
str = "Scilab control toolbox";
display(str);

mprintf("\nPolynomial:\n");
s = poly(0, "s");
p = s^2 + 3*s + 2;
display(p);

mprintf("\nTransfer function:\n");
G = syslin("c", (s + 2)/(s^2 + 3*s + 2));
display(G);

mprintf("\nState-space system:\n");
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];
D = [0];
sys = syslin("c", A, B, C, D);
display(sys);

mprintf("\nDiscrete-time state-space system:\n");
sysd = syslin(0.1, A, B, C, D);
display(sysd);

mprintf("\nList:\n");
L = list(1, "control", [1 2; 3 4]);
display(L);

mprintf("\nStructure:\n");
st.name = "system";
st.order = 2;
display(st);

mprintf("\nWrong number of inputs:\n");
try
    display();
catch
    mprintf("Error detected successfully.\n");
end

mprintf("\nWrong number of outputs:\n");
try
    out = display(A);
catch
    mprintf("Error detected successfully.\n");
end

mprintf("\nAll display checks completed successfully.\n");
