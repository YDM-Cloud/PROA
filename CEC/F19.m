classdef F19
    properties(Constant)
        D = 2;
        R = [-5, 10];
    end

    methods(Static)
        function outputArg = F(x)
            outputArg = (x(2)-5.1/(4*pi^2)*x(1)^2+5/pi*x(1)-6)^2+10*(1-1/(8*pi))*cos(x(1))+10;
        end
    end
end