classdef F42
    properties(Constant)
        D = 30;
        R = [-32, 32];
    end

    methods(Static)
        function outputArg = F(x)
            n=length(x);
            outputArg = -20*exp(-0.2*sqrt(1/n*sum(x.^2)))...
                -exp(1/n*sum(cos(2*pi*x)))+20+exp(1);
        end
    end
end