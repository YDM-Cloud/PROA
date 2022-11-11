clear;clc;

addpath("algorithms\");
addpath("CEC\");
addpath("db_operator\");
addpath("deployment\");

%% generate data
% NP=20;
% GMAX=500;
% N=50;
% D=1000;

% normal D
% CEC_functions={F1, F2, F3, F4, F5, F6, F7, F8, F9, F10,...
%     F11, F12, F13, F14, F15, F16, F17, F18, F19, F20,...
%     F21, F22, F23, F24, F25, F26, F27, F28, F29, F30,...
%     F31, F32, F33, F34, F35, F36, F37, F38, F39, F40,...
%     F41, F42, F43, F44, F45};

% for D=100,500,1000
% CEC_functions={F15, F16, F17,...
%     F22, F23, F24, F25, F26,...
%     F41, F42, F43, F44};


% clear_data();
% generate_data(CEC_functions,NP,GMAX,N,D);
% result=select_data(F15,nan,nan,D,NP,GMAX,'i');
% disp('success');

%% statistics data
% statistics_result=statistics_data(1000);

% xlswrite('statistics_data_normal_d.xlsx',statistics_result)

% statistics_result=statistics_p_best(1000);

% statistics_result=statistics_mean(1000);
% statistics_result=statistics_std(1000);

% statistics_result=statistics_p_history(nan);

