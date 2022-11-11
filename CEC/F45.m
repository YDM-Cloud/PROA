classdef F45
    properties(Constant)
        D = 2;
        R = [0, 10];
    end

    methods(Static)
        function outputArg = F(x)
            m=5;
            a=[3, 5, 5, 2, 2, 1, 1, 4, 7, 9];
            a=reshape(a,[5,2]);
            c=[1, 2, 5, 2, 3];
            ri=0;
            for i=1:m
                rj=0;
                for j=1:length(x(:))
                    rj=rj+(x(j)-a(i,j))^2;
                end
                ri=ri+c(i)*exp(-rj/pi)*cos(pi*rj);
            end
            outputArg = ri;
        end
    end
end