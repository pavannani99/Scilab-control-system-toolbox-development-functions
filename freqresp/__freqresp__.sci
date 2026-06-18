/*
 * __freqresp__.sci
 * Helper function for freqresp.sci.
 *
 * Author: Pavan Kumar
 * Year: 2026
 */

/*
Description:
Computes the frequency response of a continuous-time state-space system.
For each frequency w(k), the response is evaluated as:

H(:,:,k) = C * inv(%i*w(k)*I - A) * B + D
*/

function H = __freqresp__(sys, w)

    [A, B, C, D] = abcd(sys);

    w = matrix(w, 1, -1);
    nw = length(w);

    n = size(A, 1);
    p = size(C, 1);
    m = size(B, 2);

    H = zeros(p, m, nw);
    I = eye(n, n);

    for k = 1:nw
        s = %i * w(k);
        H(:, :, k) = C * inv(s * I - A) * B + D;
    end

endfunction
