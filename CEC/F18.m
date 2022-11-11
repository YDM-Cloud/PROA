classdef F18
    properties(Constant)
        D = 2;
        R = [-65.536, 65.536];
    end

    methods(Static)
        function outputArg = F(x)
            a=[-32, -16, 0, 16, 32, -32, -16, 0, 16, 32, -32, -16, 0, 16, 32,...
                -32, -16, 0, 16, 32, -32, -16, 0, 16, 32, -32, -32, -32, -32, -32,...
                -16, -16, -16, -16, -16, 0, 0, 0, 0, 0, 16, 16, 16, 16, 16, 32, 32, 32, 32, 32];
            a=reshape(a,[2,25]);
            rj=0;
            for j=1:25
                ri=0;
                for i=1:2
                    ri=ri+(x(i)-a(i,j))^6;
                end
                rj=rj+1/(j+ri);
            end
            outputArg = 1/(1/500+rj);
        end
    end
end