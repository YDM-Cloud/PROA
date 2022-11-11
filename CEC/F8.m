classdef F8
    properties(Constant)
        D = 2;
        R = [-10, 10];
    end

    methods(Static)
        function outputArg = F(x)
            x1 = x(1);
            x2 = x(2);
            outputArg = 0.26*(power(x1,2)+power(x2,2))-0.48*x1*x2;
        end
    end
end