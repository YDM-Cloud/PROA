classdef F22
    properties(Constant)
        D = 30;
        R = [-5.12, 5.12];
    end

    methods(Static)
        function outputArg = F(x)
            outputArg = sum(power(x,2)-10*cos(2*pi*2)+10);
        end
    end
end