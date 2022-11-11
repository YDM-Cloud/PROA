classdef F36
    properties(Constant)
        D = 4;
        R = [0, 10];
    end

    methods(Static)
        function outputArg = F(x)
            a=[4, 4, 4, 4, 1, 1, 1, 1, 8, 8, 8, 8, 6, 6, 6, 6, 3, 7, 3, 7,...
                2, 9, 2, 9, 5, 5, 3, 3, 8, 1, 8, 1, 6, 2, 6, 2,7, 3.6, 7, 3.6];
            a=reshape(a,[10,4]);
            c=[0.1, 0.2, 0.2, 0.4, 0.4, 0.6, 0.3, 0.7, 0.5, 0.5];
            r=0;
            for i=1:10
                r=r+(dot(x-a(i,:),(x-a(i,:))')+c(i))^(-1);
            end
            outputArg = r;
        end
    end
end