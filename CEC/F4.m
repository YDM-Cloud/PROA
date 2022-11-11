classdef F4
    properties(Constant)
        D = 30;
        R = [-10, 10];
    end

    methods(Static)
        function outputArg = F(x)
            i = 1:length(x(:));
            outputArg = sum(i.*(x.^2));
        end
    end
end