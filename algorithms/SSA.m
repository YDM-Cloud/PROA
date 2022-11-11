function [fMin,bestX,Convergence_curve,time_stamp_history,time_p_best_history] = SSA(x,M,lb,ub,fobj)
tic;

start_stamp=datevec(now);
time_stamp_history=[];
time_p_best_history=[];


[pop,dim]=size(x);
P_percent = 0.2;    % The population size of producers accounts for "P_percent" percent of the total population size

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pNum = round( pop *  P_percent );    % The population size of the producers


% lb= c.*ones( 1,dim );    % Lower limit/bounds/     a vector
% ub= d.*ones( 1,dim );    % Upper limit/bounds/     a vector
%Initialization
for i = 1 : pop
%     x( i, : ) = lb + (ub - lb) .* rand( 1, dim );
    fit( i ) = fobj( x( i, : ) ) ;
end
pFit = fit;
pX = x;                            % The individual's best position corresponding to the pFit
[ fMin, bestI ] = min( fit );      % fMin denotes the global optimum fitness value
bestX = x( bestI, : );             % bestX denotes the global optimum position corresponding to fMin


% Start updating the solutions.

for t = 1 : M
    [ ans, sortIndex ] = sort( pFit );% Sort.

    [fmax,B]=max( pFit );
    worse= x(B,:);

    r2=rand(1);
    if(r2<0.8)

        for i = 1 : pNum                                                   % Equation (3)
            r1=rand(1);
            x( sortIndex( i ), : ) = pX( sortIndex( i ), : )*exp(-(i)/(r1*M));
            x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );
            fit( sortIndex( i ) ) = fobj( x( sortIndex( i ), : ) );
        end
    else
        for i = 1 : pNum

            x( sortIndex( i ), : ) = pX( sortIndex( i ), : )+randn(1)*ones(1,dim);
            x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );
            fit( sortIndex( i ) ) = fobj( x( sortIndex( i ), : ) );

        end

    end


    [ fMMin, bestII ] = min( fit );
    bestXX = x( bestII, : );


    for i = ( pNum + 1 ) : pop                     % Equation (4)

        A=floor(rand(1,dim)*2)*2-1;

        if( i>(pop/2))
            x( sortIndex(i ), : )=randn(1)*exp((worse-pX( sortIndex( i ), : ))/(i)^2);
        else
            x( sortIndex( i ), : )=bestXX+(abs(( pX( sortIndex( i ), : )-bestXX)))*(A'*(A*A')^(-1))*ones(1,dim);

        end
        x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );
        fit( sortIndex( i ) ) = fobj( x( sortIndex( i ), : ) );

    end
    c=randperm(numel(sortIndex));
    b=sortIndex(c(1:length(sortIndex)));
    for j =  1  : length(b)      % Equation (5)

        if( pFit( sortIndex( b(j) ) )>(fMin) )

            x( sortIndex( b(j) ), : )=bestX+(randn(1,dim)).*(abs(( pX( sortIndex( b(j) ), : ) -bestX)));

        else

            x( sortIndex( b(j) ), : ) =pX( sortIndex( b(j) ), : )+(2*rand(1)-1)*(abs(pX( sortIndex( b(j) ), : )-worse))/ ( pFit( sortIndex( b(j) ) )-fmax+1e-50);

        end
        x( sortIndex(b(j) ), : ) = Bounds( x( sortIndex(b(j) ), : ), lb, ub );

        fit( sortIndex( b(j) ) ) = fobj( x( sortIndex( b(j) ), : ) );
    end
    for i = 1 : pop
        if ( fit( i ) < pFit( i ) )
            pFit( i ) = fit( i );
            pX( i, : ) = x( i, : );
        end

        if( pFit( i ) < fMin )
            fMin= pFit( i );
            bestX = pX( i, : );

            current_stamp=datevec(now);
            time_stamp_history=[time_stamp_history;etime( current_stamp,start_stamp)];
            time_p_best_history=[time_p_best_history;fMin];
        end
    end

    Convergence_curve(t)=fMin;

end

if sum(Convergence_curve==-inf)>0
    Convergence_curve(Convergence_curve==-inf)=1e-20;
    fMin=1e-20;
end
if sum(Convergence_curve==inf)>0
    Convergence_curve(Convergence_curve==inf)=1e20;
end


toc;
end


% Application of simple limits/bounds
function s = Bounds( s, Lb, Ub)
% Apply the lower bound vector
temp = s;
I = temp < Lb;
temp(I) = Lb(I);

% Apply the upper bound vector
J = temp > Ub;
temp(J) = Ub(J);
% Update this new move
s = temp;
end

%---------------------------------------------------------------------------------------------------------------------------
