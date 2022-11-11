classdef F5
    properties(Constant)
        D = 30;
        R = [-1.28, 1.28];
    end

    methods(Static)
        function outputArg = F(x)
            i = 1:length(x(:));
            outputArg = sum(i.*power(x,4))+rand();
        end
    end
end