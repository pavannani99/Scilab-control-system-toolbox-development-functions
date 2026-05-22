/*=========================================
zero.sci
Author: Pavan Kumar

Compute zeros and gain of LTI models.

Current support:
- SISO transfer functions
- Basic state-space systems
=========================================*/

function [z,k,info]=zero(sys,type)

    if argn(2)<2 then
        type="invariant";
    end

    type=normalize_type(type);

    z=[];
    k=[];
    info=build_info();

    select typeof(sys)

    case "rational"

        [z,k]=tf_zero(sys);
        info.rank=1;

    case "state-space"

        select type

        case "input"
            sys=input_system(sys);

        case "output"
            sys=output_system(sys);

        end

        [z,k,info]=ss_zero(sys);

    else

        error("zero: unsupported model");

    end

endfunction



function type=normalize_type(type)

    type=convstr(type,"l");

    select type

    case "inv"
        type="invariant";

    case "s"
        type="system";

    case "t"
        type="transmission";

    case "inp"
    case "id"
        type="input";

    case "o"
    case "od"
        type="output";

    case "invariant"
    case "system"
    case "transmission"
    case "input"
    case "output"

    else

        error("zero: invalid type");

    end

endfunction




function [z,k]=tf_zero(sys)

    num=coeff(sys.num);
    den=coeff(sys.den);

    num=num($:-1:1);
    den=den($:-1:1);

    if length(num)>1 then
        z=roots(num);
    else
        z=[];
    end

    if size(num,"*")>0 & size(den,"*")>0 then
        k=num(1)/den(1);
    else
        k=[];
    end

endfunction




function [z,k,info]=ss_zero(sys)

    info=build_info();

    z=[];
    k=[];

    A=sys.A;
    B=sys.B;
    C=sys.C;

    [~,inputs]=size(B);
    [outputs,~]=size(C);

    info.rank=min(inputs,outputs);

    if inputs<>1 | outputs<>1 then
        return;
    end

    try
        z=real(spec(A));
        k=1;
    catch
        z=[];
        k=[];
    end

endfunction




function tmp=input_system(sys)

    tmp=sys;

    tmp.C=[];

    tmp.D=[];

endfunction




function tmp=output_system(sys)

    tmp=sys;

    tmp.B=[];

    tmp.D=[];

endfunction




function info=build_info()

    info=struct( ...
        "rank",[], ...
        "infz",[], ...
        "kronr",[], ...
        "kronl",[] ...
    );

endfunction
