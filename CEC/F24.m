classdef F24
    properties(Constant)
        D = 2;
        R = [0, pi];
    end

    methods(Static)
        function outputArg = F(x)
            m=2;
            s = 0;
            for i = 1:length(x(:))
                s = s+(-sin(x(i))*power(sin((i+1)*x(i)^2/pi),2*m));
            end
            outputArg = s;
        end
    end
end