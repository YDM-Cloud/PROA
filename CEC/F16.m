classdef F16
    properties(Constant)
        D = 30;
        R = [-30, 30];
    end

    methods(Static)
        function outputArg = F(x)
            s=0;
            for i=1:length(x(:))-1
                s=s+100*power(x(i+1)-power(x(i),2),2)+power(x(i)-1,2);
            end
            outputArg = s;
        end
    end
end