function bool = isdetectable(a, c, e, tol, dflg)

    [lhs, rhs] = argn(0);

    if rhs < 2 then c = []; end
    if rhs < 3 then e = []; end
    if rhs < 4 then tol = []; end
    if rhs < 5 then dflg = 0; end

    if rhs == 0 then

        error(msprintf(gettext("%s: Wrong number of input arguments."), "isdetectable"));

    elseif typeof(a) == "state-space" | typeof(a) == "rational" then

        if rhs > 2 then
            error(msprintf(gettext("%s: Wrong number of input arguments."), "isdetectable"));
        end

        bool = isstabilizable(a', c);

    elseif rhs < 2 | rhs > 5 then

        error(msprintf(gettext("%s: Wrong number of input arguments."), "isdetectable"));

    else

        bool = isstabilizable(a', c', e', tol, dflg);

    end

endfunction


//=============================================================//
// Test Case 1 : Observable Continuous-Time System
//=============================================================//

A = [-1 0;
      0 2];

C = [1 1];

bool = isdetectable(A,C);

printf("\nTest Case 1\n");
printf("Expected : T\n");
printf("Obtained : %d\n", bool);


//=============================================================//
// Test Case 2 : Unobservable Stable Mode
//=============================================================//

A = [-2 0;
      0 -3];

C = [1 0];

bool = isdetectable(A,C);

printf("\nTest Case 2\n");
printf("Expected : T\n");
printf("Obtained : %d\n", bool);


//=============================================================//
// Test Case 3 : Unobservable Unstable Mode
//=============================================================//

A = [2 0;
     0 -1];

C = [0 1];

bool = isdetectable(A,C);

printf("\nTest Case 3\n");
printf("Expected : F\n");
printf("Obtained : %d\n", bool);


//=============================================================//
// Test Case 4 : Descriptor System
//=============================================================//

A = [1 0;
     0 -2];

E = eye(2,2);

C = [1 0];

bool = isdetectable(A,C,E);

printf("\nTest Case 4\n");
printf("Expected : T\n");
printf("Obtained : %d\n", bool);


//=============================================================//
// Test Case 5 : Explicit Tolerance
//=============================================================//

A = [-0.5 0;
      0 -1];

C = [1 0];

bool = isdetectable(A,C,[],1e-6);

printf("\nTest Case 5\n");
printf("Expected : T\n");
printf("Obtained : %d\n", bool);


//=============================================================//
// Test Case 6 : SISO System
//=============================================================//

A = -2;

C = 1;

bool = isdetectable(A,C);

printf("\nTest Case 6\n");
printf("Expected : T\n");
printf("Obtained : %d\n", bool);


//=============================================================//
// Test Case 7 : Zero Output Matrix with Unstable State
//=============================================================//

A = 2;

C = 0;

bool = isdetectable(A,C);

printf("\nTest Case 7\n");
printf("Expected : F\n");
printf("Obtained : %d\n", bool);


//=============================================================//
// Test Case 8 : Zero Output Matrix with Stable State
//=============================================================//

A = -2;

C = 0;

bool = isdetectable(A,C);

printf("\nTest Case 8\n");
printf("Expected : T\n");
printf("Obtained : %d\n", bool);
