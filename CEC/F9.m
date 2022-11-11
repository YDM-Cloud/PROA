classdef F9
    properties(Constant)
        D = 4;
        R = [-10, 10];
    end

    methods(Static)
        function outputArg = F(x)
            x1 = x(1);
            x2 = x(2);
            x3 = x(3);
            x4 = x(4);
            outputArg = 100*(x1^2-x2)^2+(x1-1)^2+(x3-1)^2+90*(x3^2-x4)^2+...
                10.1*((x2-1)^2+(x4-1)^2)+19.8*(x2-1)*(x4-1);
        end
    end
end