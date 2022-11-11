classdef F12
    properties(Constant)
        D = 10;
        R = [-5, 10];
    end

    methods(Static)
        function outputArg = F(x)
            a = 1:length(x(:));
            outputArg = sum(x.^2)+(sum(0.5.*a.*x.^2)).^2+(sum(0.5.*a.*x)).^4;
        end
    end
end

