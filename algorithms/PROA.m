function [Score,BestRemora,Convergence,time_stamp_history,time_p_best_history]=PROA(X,Max_iterations,Lowerbound,Upperbound,objective)
tic;
% ours

x=0:1:20;
px=poisspdf(x,6);

start_stamp=datevec(now);
time_stamp_history=[];
time_p_best_history=[];
p_best=inf;

[Search_Agents,dimensions]=size(X);
BestRemora=zeros(1,dimensions);
Score=inf;
Remora=X;
% Prevgen{1}=Remora;
Convergence=zeros(1,Max_iterations);
t=0;
while t<Max_iterations

    %% Memory of previous generation

%     if t<=1
%         PreviousRemora = Prevgen{1};
%     else
%         PreviousRemora = Prevgen{t-1};
%     end

    % Boundary check

    for i=1:size(Remora,1)
        Flag4Upperbound=Remora(i,:)>Upperbound;
        Flag4Lowerbound=Remora(i,:)<Lowerbound;
        Remora(i,:)=(Remora(i,:).*(~(Flag4Upperbound+Flag4Lowerbound)))+Upperbound.*Flag4Upperbound+Lowerbound.*Flag4Lowerbound;
        fitness=objective(Remora(i,:));

        % Evaluate fitness function of search agents

        if fitness<Score
            Score=fitness;
            BestRemora=Remora(i,:);
        end

    end

    % Make a experience attempt through equation (2)

    for j=1:size(Remora,1)
        idx=find(x==round(20-t/Max_iterations*20));
        pp=px(1,idx);

        r = floor(rand()* Search_Agents) + 1;
        while r==i
            r = floor(rand()* Search_Agents) + 1;
        end
        r1=pp;
        r2=1-pp;
        RemoraAtt=Remora(r,:)+r2.*(Remora(r,:)-Remora(j,:))+r1.*(BestRemora-Remora(r,:));

        %         RemoraAtt = Remora(j,:)+(Remora(j,:)-PreviousRemora(j,:))*randn;                    %Equation(2)

        % Calculate the fitness function value of the attempted solution (fitnessAtt)

        fitnessAtt=objective(RemoraAtt);

        % Calculate the fitness function value of the current solution (fitnessI)

        fitnessI=objective(Remora(j,:));

        % Check if the current fitness (fitnessI) is better than the attempted fitness(fitnessAtt)
        % if No, Perform host feeding by equation (9)

        if fitnessI>fitnessAtt
            % host feeding
            V = 2*(1-t/Max_iterations);                                                     % Equation (12)
            B = 2*V*rand-V;                                                                 % Equation (11)
            C = 0.1;
            A = B*(Remora(j,:)-C*BestRemora);                                               % Equation (10)
            Remora(j,:)= Remora(j,:)+A;                                                     % Equation (9)

            % If yes perform host conversion using equation (1) and (5)
        else
            rand_l=[1,3,4,5];
            rand_idx=randi([1,length(rand_l)]);
            rand_idx=rand_l(rand_idx);

%             rand_idx=randi([1,6]);
            if rand_idx==1
                % WOA strategy
                a=-(1+t/Max_iterations);                                                        % Equation (7)
                alpha = rand*(a-1)+1;                                                           % Equation (6)
                D = abs(BestRemora-Remora(j,:));                                                % Equation (8)
                Remora(j,:) = D*exp(alpha)*cos(2*pi*a)+Remora(j,:);
            elseif rand_idx==2
                % SFO strategy
                m=randperm(size(Remora,1));
                Remora(j,:)=BestRemora-((rand*(BestRemora+Remora(m(1),:))/2)-Remora(m(1),:));   % Equation (1)
            elseif rand_idx==3
                k = floor(rand()* Search_Agents) + 1;
                while k==i
                    k = floor(rand()* Search_Agents) + 1;
                end
                h = floor(rand()* Search_Agents) + 1;
                while (h==k)||(h==i)
                    h = floor(rand()* Search_Agents) + 1;
                end
                Remora(j,:)=Remora(j,:)+((rand-0.5)*2).*(Remora(j,:)-(Remora(k,:)+Remora(h,:))./2);
            elseif rand_idx==4
                d = floor(rand()* Search_Agents) + 1;
                while d==i
                    d = floor(rand()* Search_Agents) + 1;
                end
                e = floor(rand()* Search_Agents) + 1;
                while (e==d)||(e==i)
                    e = floor(rand()* Search_Agents) + 1;
                end
                f = floor(rand()* Search_Agents) + 1;
                while (f==e)||(f==d)||(f==i)
                    f = floor(rand()* Search_Agents) + 1;
                end
                Remora(j,:)=BestRemora+Remora(d,:)+rand.*(Remora(e,:)-Remora(f,:));
            elseif rand_idx==5
                Remora(j,:)=rand.*Remora(j,:)+rand.*(BestRemora-Remora(j,:));
            elseif rand_idx==6
                r = floor(rand()* Search_Agents) + 1;
                while r==i
                    r = floor(rand()* Search_Agents) + 1;
                end
                Remora(j,:)=Remora(r,:)+rand.*(Remora(r,:)-Remora(j,:))+rand.*(BestRemora-Remora(r,:));
            end
        end
    end

    t=t+1 ;
%     Prevgen{t+1}=Remora;
    Convergence(t)=Score;

    if Score<p_best
        p_best=Score;
        current_stamp=datevec(now);
        time_stamp_history=[time_stamp_history;etime( current_stamp,start_stamp)];
        time_p_best_history=[time_p_best_history;p_best];
    end
end
toc;
end

