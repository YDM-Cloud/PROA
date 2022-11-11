classdef F32
    properties(Constant)
        D = 2;
        R = [-2, 2];
    end

    methods(Static)
        function outputArg = F(x)
            x1 = x(1);
            x2 = x(2);
            r1=1+(x1+x2+1)^2*(19-14*x1+3*x1^2-14*x2+6*x1*x2+3*x2^2);
            r2=30+(2*x1-3*x2)^2*(18-32*x1+12*x1^2+48*x2-36*x1*x2+27*x2^2);
            outputArg = r1*r2;
        end
    end
end