function H = __freqresp__(sys, w)
    ty = typeof(sys);
    select ty
    case 'state-space'
        H = __freqresp_ss__(sys, w);
    case 'rational'
        H = __freqresp_tf__(sys, w);
    else
        error("freqresp: unsupported system type: " + ty);
    end
endfunction

function H = __freqresp_ss__(sys, w)
    [ny, nu] = size(sys);
    n = size(sys.A, 1);
    lw = length(w);
    H = zeros(ny, nu, lw);
    if sys.dt == 'c' | isempty(sys.dt) | sys.dt == '' then
        for k = 1:lw
            s = %i * w(k);
            mat = s*eye(n,n) - sys.A;
            x = linsolve(mat, sys.B);
            H(:,:,k) = sys.C * x + sys.D;
        end
    else
        Ts = sys.dt;
        for k = 1:lw
            z = exp(%i * w(k) * Ts);
            mat = z*eye(n,n) - sys.A;
            x = linsolve(mat, sys.B);
            H(:,:,k) = sys.C * x + sys.D;
        end
    end
endfunction

function H = __freqresp_tf__(sys, w)
    if sys.dt == 'c' | isempty(sys.dt) | sys.dt == '' then
        s = %i * w;
    else
        s = exp(%i * w * sys.dt);
    end
    resp = horner(sys, s);
    [ny, nu] = size(sys);
    lw = length(w);

    // Safe reshape for SISO
    resp = matrix(resp, ny*nu, lw);
    H = matrix(resp, ny, nu, lw);
endfunction
