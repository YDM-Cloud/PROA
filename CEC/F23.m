classdef F23
    properties(Constant)
        D = 30;
        R = [-500, 500];
    end

    methods(Static)
        function outputArg = F(x)
            outputArg = sum(-x.*sin(power(abs(x),0.5)));
        end
    end
end