classdef F37
    properties(Constant)
        D = 4;
        R = [-4, 4];
    end

    methods(Static)
        function outputArg = F(x)
            beta=0.5;
            ri=0;
            l=length(x(:));
            for i=1:l
                rj=0;
                for j=1:l
                    rj=rj+(j^i+beta)*((x(j)/j)^i-1);
                end
                ri=ri+rj^2;
            end
            outputArg = ri;
        end
    end
end