classdef F7
    properties(Constant)
        D = 2;
        R = [-100, 100];
    end

    methods(Static)
        function outputArg = F(x)
            x1 = x(1);
            x2 = x(2);
            outputArg = -cos(x1)*cos(x2)*exp(-(x1-pi)^2-(x2-pi)^2);
        end
    end
end