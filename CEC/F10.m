classdef F10
    properties(Constant)
        D = 6;
        R = [-36, 36];
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