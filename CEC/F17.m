classdef F17
    properties(Constant)
        D = 30;
        R = [-10, 10];
    end

    methods(Static)
        function outputArg = F(x)
            s = 0;
            for i=2:length(x(:))
                s=s+i*(2*x(i)^2-x(i-1))^2;
            end
            outputArg = power(x(1)-1,2)+s;
        end
    end
end