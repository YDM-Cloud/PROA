classdef F1
    properties(Constant)
        D = 5;
        R = [-5.12, 5.12];
    end

    methods(Static)
        function outputArg = F(x)
            outputArg = 25+sum(floor(x));
        end
    end
end

