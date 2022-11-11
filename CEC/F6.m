classdef F6
    properties(Constant)
        D = 2;
        R = [-4.5, 4.5];
    end

    methods(Static)
        function outputArg = F(x)
            x1 = x(1);
            x2 = x(2);
            outputArg = (1.5-x1+x1*x2)^2+(2.25-x1+x1*x2^2)^2+(2.625-x1+x1*x2^3)^2;
        end
    end
end