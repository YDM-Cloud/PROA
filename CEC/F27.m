classdef F27
    properties(Constant)
        D = 2;
        R = [-100, 100];
    end

    methods(Static)
        function outputArg = F(x)
           r1=(sin(sqrt(x(1)^2+x(2)^2)))^2-0.5;
           r2=(1+0.001*(x(1)^2+x(2)^2))^2;
            outputArg = 0.5+r1/r2;
        end
    end
end