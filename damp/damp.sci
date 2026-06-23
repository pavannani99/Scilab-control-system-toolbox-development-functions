## Copyright (C) 2017 Mark Bronsfeld
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program. If not, see <https://www.gnu.org/licenses/>.

## Author: Mark Bronsfeld <m.brnsfld@googlemail.com>
## Created: January 2017
## Version: 0.1
## 2026 Scilab translation: ALLU RAM CHARAN

function [Wn_out, zeta, P] = damp(sys)

    [nargout, nargin] = argn();

    if nargin == 1 then // damp(sys)

        is_lti = (typeof(sys) == "state-space" | typeof(sys) == "rational");

        if is_lti then
            is_square = %f;
        elseif or(type(sys) == [1, 5, 8]) then
            [number_of_rows, number_of_columns] = size(sys);
            is_square = (number_of_rows == number_of_columns);
        else
            is_square = %f;
        end

        if ~(is_lti | is_square) then
            error("damp: argument must be an LTI system");
        end

    else
        error("damp: wrong number of input arguments");
    end

    // Octave source: P = pole(sys)
    // The accepted Scilab pole dependency cannot process state-space lss
    // objects because it calls issquare(sys). Therefore only this one line
    // requires a Scilab compatibility branch.
    if typeof(sys) == "state-space" then
        P = spec(sys.A);
    else
        P = pole(sys);
    end

    P = matrix(P, -1, 1); // Poles

    // Distinguish between system/state matrices, continuous- and
    // discrete-time models.
    if (~is_lti & is_square) then
        s = P;

    elseif isct(sys) then
        s = P;

    elseif isdt(sys) then

        if type(sys.dt) == 10 & convstr(sys.dt, "l") == "d" then
            // If sample time is unspecified, assume one second:
            // log(P) / 1.
            s = log(P);
        else
            s = log(P) ./ sys.dt;
        end

        mag = abs(P); // Magnitude
    end

    Wn = abs(s); // Frequencies (rad / seconds)

    // Sort all vectors in order of increasing natural frequency.
    [Wn, ndx] = gsort(Wn, "g", "i");
    P = P(ndx);
    s = s(ndx);

    zeta = -cos(atan(imag(s), real(s))); // Damping

    tau = 1 ./ (Wn .* zeta); // Time constant (seconds)

    // Suppress "ans" output if no output is specified.
    if nargout > 0 then
        Wn_out = Wn;

    // Display overview table when no output is specified.
    elseif nargout == 0 then

        // Type conversion and formatting to exponential format.
        P = __damp_num2str__(P);
        zeta = __damp_num2str__(zeta);
        Wn = __damp_num2str__(Wn);
        tau = __damp_num2str__(tau);

        // Construct columns of overview table.
        Pole = ["Pole"; " "; " "; P];
        Damping = ["Damping"; " "; " "; zeta];
        Frequency = ["Frequency"; "(rad/seconds)"; " "; Wn];
        TimeConstant = ["Time Constant"; "(seconds)"; " "; tau];

        space_3 = emptystr(size(Pole, 1), 3);
        space_3(:) = " ";

        space_4 = emptystr(size(Pole, 1), 4);
        space_4(:) = " ";

        // Construct overview table and distinguish between system/state
        // matrices, continuous- and discrete-time models.
        if (~is_lti & is_square) then

            overview_table = [space_3, Pole, ..
                              space_4, Damping, ..
                              space_4, Frequency, ..
                              space_4, TimeConstant];

        elseif isct(sys) then

            overview_table = [space_3, Pole, ..
                              space_4, Damping, ..
                              space_4, Frequency, ..
                              space_4, TimeConstant];

        elseif isdt(sys) then

            mag = mag(ndx); // Sort by increasing natural frequency.
            mag = __damp_num2str__(mag);

            Magnitude = ["Magnitude"; " "; " "; mag];

            overview_table = [space_3, Pole, ..
                              space_4, Magnitude, ..
                              space_4, Damping, ..
                              space_4, Frequency, ..
                              space_4, TimeConstant];
        end

        for row = 1:size(overview_table, 1)
            mprintf("%s\n", strcat(overview_table(row, :)));
        end
    end

endfunction


// Scilab equivalent of Octave num2str(x, "%1.2e").
// Scilab msprintf ignores the imaginary part of complex numbers, so the
// complex formatting is handled explicitly.
function output_string = __damp_num2str__(x)

    x = matrix(x, -1, 1);
    output_string = emptystr(size(x, 1), 1);

    for k = 1:size(x, 1)

        real_part = real(x(k));
        imaginary_part = imag(x(k));

        if abs(imaginary_part) <= %eps * max(1, abs(real_part)) then
            output_string(k) = msprintf("%1.2e", real_part);

        elseif imaginary_part > 0 then
            output_string(k) = msprintf("%1.2e + %1.2ei", ..
                                        real_part, imaginary_part);

        else
            output_string(k) = msprintf("%1.2e - %1.2ei", ..
                                        real_part, abs(imaginary_part));
        end
    end

endfunction


// Test helper: compare pole vectors without depending on conjugate order.
function result = __damp_same_poles__(observed, expected, tolerance)

    observed = matrix(observed, -1, 1);
    expected = matrix(expected, -1, 1);

    if size(observed, "*") <> size(expected, "*") then
        result = %f;
        return;
    end

    matched = zeros(size(expected, "*"), 1) == 1;
    result = %t;

    for i = 1:size(observed, "*")

        found = %f;

        for j = 1:size(expected, "*")

            if ~matched(j) & abs(observed(i) - expected(j)) <= tolerance then
                matched(j) = %t;
                found = %t;
                break;
            end
        end

        if ~found then
            result = %f;
            return;
        end
    end

endfunction


// -------------------------------------------------------------------------
// TEST CASES
// Load dependencies before executing this file:
// issiso.sci, pole.sci, isct.sci and isdt.sci
// -------------------------------------------------------------------------

// Test Case 1: Continuous-time state-space model.
A1 = [-1, 0, 0;
       0, -2, 0;
       0, 0, -3];
B1 = ones(3, 1);
C1 = eye(3, 3);
D1 = zeros(3, 1);
H1 = syslin("c", A1, B1, C1, D1);

Wn_expected_1 = [1; 2; 3];
zeta_expected_1 = [1; 1; 1];
P_expected_1 = [-1; -2; -3];

[Wn_observed_1, zeta_observed_1, P_observed_1] = damp(H1);

if norm(Wn_observed_1 - Wn_expected_1, %inf) <= 1d-12 & ..
   norm(zeta_observed_1 - zeta_expected_1, %inf) <= 1d-12 & ..
   norm(P_observed_1 - P_expected_1, %inf) <= 1d-12 then
    disp("Test Case 1: Continuous-time state-space model passed");
else
    error("Test Case 1 failed");
end


// Test Case 2: Continuous-time transfer-function model.
s2 = poly(0, "s");
H2 = syslin("c", (2*s2^2 + 5*s2 + 1) / (s2^2 + 2*s2 + 3));

Wn_expected_2 = [1.7321; 1.7321];
zeta_expected_2 = [0.5774; 0.5774];
P_expected_2 = [-1.0000 + 1.4142*%i;
                -1.0000 - 1.4142*%i];

[Wn_observed_2, zeta_observed_2, P_observed_2] = damp(H2);

if norm(Wn_observed_2 - Wn_expected_2, %inf) <= 1d-4 & ..
   norm(zeta_observed_2 - zeta_expected_2, %inf) <= 1d-4 & ..
   __damp_same_poles__(P_observed_2, P_expected_2, 1d-4) then
    disp("Test Case 2: Continuous-time transfer-function model passed");
else
    error("Test Case 2 failed");
end


// Test Case 3: Discrete-time model with specified sample time.
z3 = poly(0, "z");
H3 = syslin(0.01, (5*z3^2 + 3*z3 + 1) / ..
                     (z3^3 + 6*z3^2 + 4*z3 + 4));

Wn_expected_3 = [193.4924; 193.4924; 356.5264];
zeta_expected_3 = [0.0774; 0.0774; -0.4728];
P_expected_3 = [-0.3020 + 0.8063*%i;
                -0.3020 - 0.8063*%i;
                -5.3961 + 0.0000*%i];

[Wn_observed_3, zeta_observed_3, P_observed_3] = damp(H3);

if norm(Wn_observed_3 - Wn_expected_3, %inf) <= 1d-4 & ..
   norm(zeta_observed_3 - zeta_expected_3, %inf) <= 1d-4 & ..
   __damp_same_poles__(P_observed_3, P_expected_3, 1d-4) then
    disp("Test Case 3: Discrete-time model with specified sample time passed");
else
    error("Test Case 3 failed");
end


// Test Case 4: Discrete-time model with unspecified sample time.
H4 = syslin("d", (z3 + 0.2) / ((z3 - 0.5) * (z3 - 0.25)));

[Wn_observed_4, zeta_observed_4, P_observed_4] = damp(H4);

P_expected_4 = [0.5; 0.25];
s_expected_4 = log(P_expected_4);
Wn_expected_4 = abs(s_expected_4);
zeta_expected_4 = -cos(atan(imag(s_expected_4), real(s_expected_4)));

[Wn_expected_4, index_4] = gsort(Wn_expected_4, "g", "i");
P_expected_4 = P_expected_4(index_4);
zeta_expected_4 = zeta_expected_4(index_4);

if norm(Wn_observed_4 - Wn_expected_4, %inf) <= 1d-12 & ..
   norm(zeta_observed_4 - zeta_expected_4, %inf) <= 1d-12 & ..
   norm(P_observed_4 - P_expected_4, %inf) <= 1d-12 then
    disp("Test Case 4: Unspecified discrete sample time passed");
else
    error("Test Case 4 failed");
end


// Test Case 5: Numeric square state matrix.
A5 = [-1, 0;
       0, -2];

[Wn_observed_5, zeta_observed_5, P_observed_5] = damp(A5);

if norm(Wn_observed_5 - [1; 2], %inf) <= 1d-12 & ..
   norm(zeta_observed_5 - [1; 1], %inf) <= 1d-12 & ..
   norm(P_observed_5 - [-1; -2], %inf) <= 1d-12 then
    disp("Test Case 5: Numeric square state matrix passed");
else
    error("Test Case 5 failed");
end


// Test Case 6: No-output overview table.
damp(H2);
disp("Test Case 6: No-output overview table displayed successfully");


// Test Case 7: Invalid non-LTI and non-square argument.
error_number_7 = execstr("damp([1, 2, 3]);", "errcatch");

if error_number_7 <> 0 then
    disp("Test Case 7: Invalid argument detected successfully");
else
    error("Test Case 7 failed");
end


// Test Case 8: Wrong number of input arguments.
error_number_8 = execstr("damp();", "errcatch");

if error_number_8 <> 0 then
    disp("Test Case 8: Wrong number of input arguments detected successfully");
else
    error("Test Case 8 failed");
end
