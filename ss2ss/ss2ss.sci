/* Scilab translation: Pavan Kumar */
/* ss2ss.sci
applies a similarity transformation to a state-space model */
/*
Description:
      Applies the similarity transformation T to a state-space model.
      Given the state-space model
            xdot = A x + B u
            y    = C x + D u
      and a transformation matrix T mapping the state vector x to a
      new coordinate system, returns the equivalent transformed
      state-space model.
      Note: T as defined here follows the Matlab convention, which is
      the inverse of T as defined by Goodwin, Graebe, Salgado (2000).
Calling Sequence:
      SYS_T = ss2ss(SYS, T)
      [A_T, B_T, C_T, D_T] = ss2ss(A, B, C, D, T)
Dependencies:
      ssdata
References:
      Control System Design, page 484 by Goodwin, Graebe, Salgado, 2000
Original Author (Octave): Fabian Alexander Wilms <f.alexander.wilms@gmail.com>
*/
function [first_out, second_out, third_out, fourth_out] = ss2ss(first_in, second_in, third_in, fourth_in, fifth_in)
    [lhs, rhs] = argn(0);
    if rhs <> 2 & rhs <> 5 then
        error("ss2ss: wrong number of input arguments");
    end
    select rhs
    case 2 then
        [A, B, C, D] = ssdata(first_in);
        T = inv(second_in);
    case 5 then
        A = first_in;
        B = second_in;
        C = third_in;
        D = fourth_in;
        T = inv(fifth_in);
    end
    A_T = inv(T) * A * T;
    B_T = inv(T) * B;
    C_T = C * T;
    D_T = D;
    select rhs
    case 2 then
        if lhs > 1 then
            error("ss2ss: too many output arguments");
        end
        first_out = syslin("c", A_T, B_T, C_T, D_T);
    case 5 then
        if lhs > 4 then
            error("ss2ss: too many output arguments");
        end
        first_out = A_T;
        second_out = B_T;
        third_out = C_T;
        fourth_out = D_T;
    end
endfunction

// test case 1: 2-input form, syslin object + T
A1 = [1 2 3; 4 5 6; 7 8 9];
B1 = [1; 2; 3];
C1 = [-1 0 1];
D1 = 0;
[T1, E1] = spec(A1);
sys1 = syslin("c", A1, B1, C1, D1);
sys1_T = ss2ss(sys1, T1);
disp("test case 1:");
disp("sys1_T.A:", sys1_T.A);
disp("sys1_T.B:", sys1_T.B);
disp("sys1_T.C:", sys1_T.C);
disp("sys1_T.D:", sys1_T.D);

// test case 2: retransform back with inv(T), should recover original system
sys1_back = ss2ss(sys1_T, inv(T1));
disp("test case 2:");
disp("sys1_back.A:", sys1_back.A);
disp("sys1_back.B:", sys1_back.B);
disp("sys1_back.C:", sys1_back.C);
disp("sys1_back.D:", sys1_back.D);

// test case 3: 5-input form, matrices + T directly
[A1_T, B1_T, C1_T, D1_T] = ss2ss(A1, B1, C1, D1, T1);
disp("test case 3:");
disp("A1_T:", A1_T);
disp("B1_T:", B1_T);
disp("C1_T:", C1_T);
disp("D1_T:", D1_T);

// test case 4: diagonal transformation matrix
A4 = [0 1; -2 -3];
B4 = [0; 1];
C4 = [1 0];
D4 = 0;
T4 = [2 0; 0 1];
sys4 = syslin("c", A4, B4, C4, D4);
sys4_T = ss2ss(sys4, T4);
disp("test case 4:");
disp("sys4_T.A:", sys4_T.A);
disp("sys4_T.B:", sys4_T.B);
disp("sys4_T.C:", sys4_T.C);
disp("sys4_T.D:", sys4_T.D);

// test case 5: identity transformation, system should remain unchanged
A5 = [1 2; 3 4];
B5 = [1; 0];
C5 = [0 1];
D5 = 0;
T5 = eye(2,2);
sys5 = syslin("c", A5, B5, C5, D5);
sys5_T = ss2ss(sys5, T5);
disp("test case 5:");
disp("sys5_T.A:", sys5_T.A);
disp("sys5_T.B:", sys5_T.B);
disp("sys5_T.C:", sys5_T.C);
disp("sys5_T.D:", sys5_T.D);
