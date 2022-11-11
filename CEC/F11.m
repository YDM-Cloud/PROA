classdef F11
    properties(Constant)
        D = 10;
        R = [-100, 100];
    end

    methods(Static)
        function outputArg = F(x)
            s = 0;
            for i = 2:length(x(:))
                s = s+x(i)*x(i-1);
            end
            outputArg = sum((x-1).^2)-s;
        end
    end
end

