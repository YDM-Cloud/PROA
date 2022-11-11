classdef F43
    properties(Constant)
        D = 30;
        R = [-50, 50];
    end

    methods(Static)
        function outputArg = u(x, a, k, m)
            if x>a
                outputArg = k*power(x-a,m);
            elseif x>=-a || x<=a
                outputArg = 0;
            elseif x<(-a)
                outputArg = k*power(-x-a,m);
            end
        end

        function outputArg = F(x)
            y=1+(1/4).*(x+1);
            sum_u=0;
            for i=1:length(x)
                sum_u=sum_u+F43.u(x(i),10,100,4);
            end
            outputArg = (pi/length(x(:)))*(10*(sin(pi*y(1)))^2+(sum((y-1).^2)-(y(end)-1)^2)*(1+10*(sin(pi*y(1)))^2)...
                +(y(end)-1)^2)+sum_u;
        end


    end
end