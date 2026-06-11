/* 2026 Author: Pavan Kumar */

funcprot(0);

function display(obj)
    if argn(2) <> 1 then
        error(msprintf(_("%s: Wrong number of input arguments: 1 expected.\n"), "display"));
    end

    select typeof(obj)

    case "state-space"
        A = obj.A; B = obj.B; C = obj.C; D = obj.D;

        nstates  = size(A, 1);
        ninputs  = size(B, 2);
        noutputs = size(C, 1);

        xlabels = [];
        for i = 1:nstates,  xlabels($+1)  = "x" + string(i); end
        ulabels = [];
        for i = 1:ninputs,  ulabels($+1)  = "u" + string(i); end
        ylabels = [];
        for i = 1:noutputs, ylabels($+1)  = "y" + string(i); end

        function print_labeled_matrix(mat, rowlbls, collbls, matname)
            mprintf("%s =\n", matname);
            ncols = size(mat, 2);
            nrows = size(mat, 1);
            col_w = [];
            for j = 1:ncols
                w = length(collbls(j));
                for i = 1:nrows
                    w = max(w, length(string(mat(i,j))));
                end
                col_w($+1) = w + 2;
            end
            row_label_w = 0;
            for i = 1:nrows
                row_label_w = max(row_label_w, length(rowlbls(i)));
            end
            row_label_w = row_label_w + 3;

            // header
            header = blanks(row_label_w);
            for j = 1:ncols
                lbl = collbls(j);
                header = header + blanks(col_w(j) - length(lbl)) + lbl;
            end
            mprintf("%s\n", header);

            // rows
            for i = 1:nrows
                rlbl = rowlbls(i);
                line = blanks(row_label_w - length(rlbl) - 1) + rlbl + " ";
                for j = 1:ncols
                    val = string(mat(i,j));
                    line = line + blanks(col_w(j) - length(val)) + val;
                end
                mprintf("%s\n", line);
            end
            mprintf("\n");
        endfunction

        print_labeled_matrix(A, xlabels, xlabels, "sys.a");
        print_labeled_matrix(B, xlabels, ulabels, "sys.b");
        print_labeled_matrix(C, ylabels, xlabels, "sys.c");
        print_labeled_matrix(D, ylabels, ulabels, "sys.d");

        if obj.dt == "c" then
            mprintf("Continuous-time model.\n");
        else
            mprintf("Discrete-time model (dt = %s).\n", string(obj.dt));
        end

    case "rational"
        num = obj.num;
        den = obj.den;

        function str = poly_to_str(p)
            c = coeff(p);
            deg = length(c) - 1;
            str = "";
            for k = deg:-1:0
                val = c(k+1);
                if val == 0 then continue; end
                if str <> "" then
                    if val > 0 then str = str + " + ";
                    else str = str + " - "; val = -val;
                    end
                else
                    if val < 0 then str = "-"; val = -val; end
                end
                if k == 0 then
                    str = str + string(val);
                elseif k == 1 then
                    if val == 1 then str = str + "s";
                    else str = str + string(val) + " s";
                    end
                else
                    if val == 1 then str = str + "s^" + string(k);
                    else str = str + string(val) + " s^" + string(k);
                    end
                end
            end
            if str == "" then str = "0"; end
        endfunction

        nouts = size(num, 1);
        nins  = size(num, 2);

        mprintf("Transfer function from input to output ...\n\n");

        for j = 1:nins
            for i = 1:nouts
                n_str   = poly_to_str(num(i,j));
                d_str   = poly_to_str(den(i,j));
                bar_len = max(length(n_str), length(d_str)) + 2;
                bar     = part("-", ones(1, bar_len));
                n_pad   = int((bar_len - length(n_str)) / 2);
                d_pad   = int((bar_len - length(d_str)) / 2);
                ylabel  = "y" + string(i) + ":";
                indent  = blanks(length(ylabel) + 2);
                mprintf("%s  %s\n", indent, blanks(n_pad) + n_str);
                mprintf("%s  %s\n", ylabel, bar);
                mprintf("%s  %s\n", indent, blanks(d_pad) + d_str);
            end
        end
        mprintf("\n");

    case "list"
        mprintf("{\n");
        for i = 1:length(obj)
            mprintf("  [1,%d] =\n", i);
            disp(obj(i));
        end
        mprintf("}\n");

    case "st"
        fields = fieldnames(obj);
        for i = 1:length(fields)
            mprintf("  .%s =\n", fields(i));
            disp(obj(fields(i)));
        end

    else
        disp(obj);
    end

endfunction


// ── Test Cases ──

display(10);
display([1 2; 3 4]);
display("Hello");
display([]);
display([%t %f; %f %t]);
display([1+2*%i, 3-4*%i]);

A = [-1,0;0,-2]; B = [1;1]; C = [1,0]; D = [0];
display(syslin("c", A, B, C, D));

s = poly(0, "s");
display(syslin("c", (s+2), (s+1)*(s+3)));

try
    display(1, 2);
catch
    mprintf("Test Passed: wrong arg count caught\n");
end

try
    display();
catch
    mprintf("Test Passed: zero args caught\n");
end
