classdef F38
    properties(Constant)
        D = 4;
        R = [0, 4];
    end

    methods(Static)
        function outputArg = F(x)
            l=length(x(:));
            rk=0;
            b=[8, 18, 44, 114];
            for k=1:l
                ri=0;
                for i=1:l
                    ri=ri+x(i)^k;
                end
                rk=rk+(ri-b(k))^2;
            end
            outputArg = rk;
        end
    end
end