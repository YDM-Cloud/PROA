classdef F44
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
            r=0;
            for i=1:length(x(:))-1
                r=r+(x(i)-1)^2*(1+(sin(3*pi*x(i+1)))^2);
            end
            sum_u=0;
            for i=1:length(x)
                sum_u=sum_u+F43.u(x(i),5,100,4);
            end
            outputArg = 0.1*((sin(pi*x(1)))^2+r+(x(end)-1)^2*(1+(sin(2*pi*x(end)))^2))...
                +sum_u;
        end
    end
end