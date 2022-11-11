classdef F21
    properties(Constant)
        D = 2;
        R = [-10, 10];
    end

    methods(Static)
        function outputArg = F(x)
            outputArg = (x(1)+2*x(2)-7)^2+(2*x(1)+x(2)-5)^2;
        end
    end
end