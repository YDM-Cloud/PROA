classdef F33
    properties(Constant)
        D = 4;
        R = [-5, 5];
    end

    methods(Static)
        function outputArg = F(x)
            a=[0.1957, 0.1947, 0.1735, 0.1600, 0.0844, 0.0627, 0.0456, 0.0342, 0.0323, 0.0235, 0.0246];
            b=[0.25, 0.5, 1, 2, 4, 6, 8, 10, 12, 14, 16];
            b = 1 ./ b;
            outputArg = sum(a-(x(1).*(b.^2+b.*x(2)))./(b.^2+b.*x(3)+x(4)).^2);
        end
    end
end