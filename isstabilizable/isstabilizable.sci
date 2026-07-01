function bool = isstabilizable (a, b, e, tol, dflg)
  
    [lhs, rhs] = argn(0);
    if rhs < 2 then b = []; end
    if rhs < 3 then e = []; end
    if rhs < 4 then tol = []; end
    if rhs < 5 then dflg = 0; end

    
    if (rhs < 1 | rhs > 5) then
        error(msprintf(gettext("%s: Wrong number of input arguments."), "isstabilizable"));

    
    elseif typeof(a) == "state-space" | typeof(a) == "rational" then
        if rhs > 2 then
            error(msprintf(gettext("%s: Wrong number of input arguments."), "isstabilizable"));
        end

       
        if typeof(a) == "rational" then
            warning("isstabilizable: converting to minimal state-space realization");
           
            a = ss(a);
        end

        tol = b;
        dflg = ~isct(a);
        [a, b, c, d, e] = ssdata(a, []);

    elseif rhs == 1 then
        error(msprintf(gettext("%s: Wrong number of input arguments."), "isstabilizable"));

    
   elseif type(a) <> 1 | ~isreal(a) | size(a,1) <> size(a,2) | size(a,1) <> size(b,1) then
    error("isstabilizable: a must be square and conformal to b");
elseif ~isempty(e) & (type(e) <> 1 | ~isreal(e) | size(e,1) <> size(e,2) | ~and(size(a)==size(e))) then
    error("isstabilizable: e must be square and conformal to a");
end
   
    if isempty(tol) then
        tol = 0;
    elseif ~(isreal(tol) & size(tol, 1) * size(tol, 2) == 1) then
        error("isstabilizable: tol must be a real scalar");
    end

   
    if isempty(e) then
        
        [ac, d1, d2, ncont] = __sl_ab01od__(a, b, tol);

      
        uncont_idx = (ncont + 1) : size(a, 1);
        auncont = ac(uncont_idx, uncont_idx);

     
        pol = spec(auncont);
    else
        
        c_dummy = zeros(1, size(a, 2));
        [ac, ec, d1, d2, d3, d4, ncont] = __sl_tg01hd__(a, e, b, c_dummy, tol);

        
        uncont_idx = (ncont + 1) : size(a, 1);
        auncont = ac(uncont_idx, uncont_idx);
        euncont = ec(uncont_idx, uncont_idx);

      
        pol = spec(auncont, euncont);

       
        tolinf = norm([auncont, euncont], 2);
        idx = find(abs(pol) < tolinf / %eps);
        pol = pol(idx);
    end

  
    bool = __is_stable__(pol, ~dflg, tol);
endfunction




//-------------------------------------------------------------//
// Test Case 1: Controllable Continuous-Time System
//-------------------------------------------------------------//

A = [-1 0;
      0 2];

B = [1;
     1];

bool = isstabilizable(A,B);

printf("\nTest Case 1\n");
printf("Expected : T\n");
printf("Obtained : %d\n", bool);


//-------------------------------------------------------------//
// Test Case 2: Uncontrollable Stable Mode
//-------------------------------------------------------------//

A = [-2 0;
      0 -3];

B = [1;
     0];

bool = isstabilizable(A,B);

printf("\nTest Case 2\n");
printf("Expected : T\n");
printf("Obtained : %d\n", bool);


//-------------------------------------------------------------//
// Test Case 3: Uncontrollable Unstable Mode
//-------------------------------------------------------------//

A = [2 0;
     0 -1];

B = [0;
     1];

bool = isstabilizable(A,B);

printf("\nTest Case 3\n");
printf("Expected : F\n");
printf("Obtained : %d\n", bool);


//-------------------------------------------------------------//
// Test Case 4: Descriptor System (E = I)
//-------------------------------------------------------------//

A = [1 0;
     0 -2];

E = eye(2,2);

B = [1;
     0];

bool = isstabilizable(A,B,E);

printf("\nTest Case 4\n");
printf("Expected : T\n");
printf("Obtained : %d\n", bool);


//-------------------------------------------------------------//
// Test Case 5: Explicit Tolerance
//-------------------------------------------------------------//

A = [-0.5 0;
      0 -1];

B = [1;
     0];

bool = isstabilizable(A,B,[],1e-6);

printf("\nTest Case 5\n");
printf("Expected : T\n");
printf("Obtained : %d\n", bool);


//-------------------------------------------------------------//
// Test Case 6: SISO System
//-------------------------------------------------------------//

A = -2;

B = 1;

bool = isstabilizable(A,B);

printf("\nTest Case 6\n");
printf("Expected : T\n");
printf("Obtained : %d\n", bool);


//-------------------------------------------------------------//
// Test Case 7: Zero Input Matrix, Unstable State
//-------------------------------------------------------------//

A = 2;

B = 0;

bool = isstabilizable(A,B);

printf("\nTest Case 7\n");
printf("Expected : F\n");
printf("Obtained : %d\n", bool);


//-------------------------------------------------------------//
// Test Case 8: Zero Input Matrix, Stable State
//-------------------------------------------------------------//

A = -2;

B = 0;

bool = isstabilizable(A,B);

printf("\nTest Case 8\n");
printf("Expected : T\n");
printf("Obtained : %d\n", bool);
