/*=====================================================
Author: Pavan Kumar
Function: zero
Description:
Compute zeros and gain of LTI model.

Supported:
- invariant
- transmission
- system
- input
- output

Current support:
- Transfer function models
- Basic state-space models

=====================================================*/

function [z,k,info]=zero(sys,type)

    //---------------------------------
    // Default argument
    //---------------------------------

    if argn(2)<2 then
        type="invariant";
    end

    //---------------------------------
    // Initialize
    //---------------------------------

    z=[];
    k=[];
    info=struct();



    //=================================================
    // TRANSFER FUNCTION
    //=================================================

    if typeof(sys)=="rational" then

        num=coeff(sys.num);
        den=coeff(sys.den);

        num=num($:-1:1);

        if length(num)<=1 then
            z=[];
        else
            z=roots(num);
        end

        select convstr(type)

        case "invariant"
            ;

        case "system"
            ;

        case "transmission"
            ;

        case "input"
            z=[];

        case "output"
            z=[];

        else
            error("Unknown zero type")

        end

        if size(num,"*")>0 & size(den,"*")>0 then
            k=num(1)/den(1);
        end

        info.rank=1;
        info.infz=[];
        info.kronr=[];
        info.kronl=[];

        return

    end



    //=================================================
    // STATE SPACE
    //=================================================

    if typeof(sys)=="state-space" then

        A=sys.A;
        B=sys.B;
        C=sys.C;
        D=sys.D;

        s=%s;

        //---------------------------------
        // Transfer function construction
        //---------------------------------

        den=det(s*eye(A)-A);

        M=s*eye(A)-A;

        adjM=[ M(2,2), -M(1,2)
              -M(2,1),  M(1,1)];

        num=C*adjM*B + D*den;

        num=coeff(num);

        num=num($:-1:1);

        if length(num)<=1 then
            z=[];
        else
            z=roots(num);
        end


        select convstr(type)

        case "invariant"
            ;

        case "transmission"
            ;

        case "system"
            ;

        case "input"
            z=[];

        case "output"
            z=[];

        else
            error("Unknown zero type")

        end


        k=[];

        info.rank=size(A,1);

        info.infz=[];
        info.kronr=[];
        info.kronl=[];

        return

    end





    error("Unsupported LTI model")

endfunction
