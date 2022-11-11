classdef F13
    properties(Constant)
        D = 24;
        R = [-4, 5];
    end

    methods(Static)
        function outputArg = F(x)
            s=0;
            for i=1:6
                s=s+(x(4*i-3)+10*x(4*i-2))^2+5*(x(4*i-1)-x(4*i))^2+(x(4*i-2)-x(4*i-1))^4+...
                    10*(x(4*i-3)-x(4*i))^4;
            end
            outputArg = s;
        end
    end
end