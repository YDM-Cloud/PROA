classdef F20
    properties(Constant)
        D = 2;
        R = [-100, 100];
    end

    methods(Static)
        function outputArg = F(x)
            outputArg = x(1)^2+2*x(2)^2-0.3*cos(3*pi*x(1))-0.4*cos(4*pi*x(2))+0.7;
        end
    end
end