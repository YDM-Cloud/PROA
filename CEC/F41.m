classdef F41
    properties(Constant)
        D = 30;
        R = [-600, 600];
    end

    methods(Static)
        function outputArg = F(x)
            a=1:length(x(:));
            outputArg = sum(x.^2)/4000-prod(cos(x./a))+1;
        end
    end
end