classdef F2
    properties(Constant)
        D = 30;
        R = [-100, 100];
    end

    methods(Static)
        function outputArg = F(x)
            outputArg = sum(power(floor(x+0.5),2));
        end
    end
end