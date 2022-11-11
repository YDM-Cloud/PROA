classdef F31
    properties(Constant)
        D = 2;
        R = [-10, 10];
    end

    methods(Static)
        function outputArg = F(x)
            r1=0;
            r2=0;
            for i=1:5
                r1=r1+i*cos((i+1)*x(1)+i);
                r2=r2+i*cos((i+1)*x(2)+i);
            end
            outputArg = r1*r2;
        end
    end
end

