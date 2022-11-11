classdef F14
    properties(Constant)
        D = 30;
        R = [-10, 10];
    end

    methods(Static)
        function outputArg = F(x)
            outputArg = sum(abs(x))+prod(abs(x));
        end
    end
end