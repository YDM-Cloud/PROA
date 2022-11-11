classdef F28
    properties(Constant)
        D = 2;
        R = [-5, 5];
    end

    methods(Static)
        function outputArg = F(x)
            outputArg = 4*x(1)^2-2.1*x(1)^4;+1/3*x(1)^6+x(1)*x(2)-4*x(2)^2+4*x(2)^4;
        end
    end
end