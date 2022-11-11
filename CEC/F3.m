classdef F3
    properties(Constant)
        D = 30;
        R = [-100, 100];
    end

    methods(Static)
        function outputArg = F(x)
            outputArg = sum(power(x,2));
        end
    end
end