classdef F39
    properties(Constant)
        D = 3;
        R = [0, 1];
    end

    methods(Static)
        function outputArg = F(x)
            a=[3, 10, 30, 0.1, 10, 35, 3, 10, 30, 0.1, 10, 35];
            a=reshape(a,[4,3]);
            c=[1, 1.2, 3, 3.2];
            p=[0.3689, 0.1170, 0.2673, 0.4699, 0.4387, 0.7470,...
                0.1091, 0.8732, 0.5547, 0.038150, 0.5743, 0.8828];
            p=reshape(p,4,3);
            r=0;
            for i=1:4
                r=r-c(i)*exp(-(sum(a(i,:).*(x-p(i,:)).^2)));
            end
            outputArg = r;
        end
    end
end