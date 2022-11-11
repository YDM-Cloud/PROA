classdef F15
    properties(Constant)
        D = 30;
        R = [-100, 100];
    end

    methods(Static)
        function outputArg = F(x)
            l=length(x);
            re=zeros(1,l);
            s=0;
            for i=1:l
                s=s+x(i);
                re(i)=s;
            end
            outputArg = sum(power(re,2));
        end
    end
end