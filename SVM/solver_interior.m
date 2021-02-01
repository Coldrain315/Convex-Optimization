function [optSol, optLambda] = solver_interior(X, Y, setPara)
% Get the optimal solution using interior point algorithm and get the
% optimal lamda using five fold cross-validation from the given lamda set
%
% INPUTS:
%   X(MxN) : trData(i,j) is the i-th feature from the j-th trial
%   Y(Nx1): trData(j) is the label of the j-th trial (1 or -1)
%   setPara : Initialized parameters
%
% OUTPUTS:
%   optiLamda: Optimal lamda value 
%   optSol: the optimal solution     
%
% @Yu Leng, yl597@duke.edu
% @3-16

W = (setPara.W)';      
C = setPara.C;
num = size(X,1);
score=zeros(5,4);
class1 = X(:,1:100);
class2 = X(:,101:end);
label1 = Y(1:100);
label2 = Y(101:end);
Ac_interior= ones(1,size(1,4)); % store number of correct prediction for each lambda
max_cor = 0;
for j=1:4
    lambda=0.01*(100^(j-1));  
    cor=0;
    for i=1:5
        test_index = 20*(i-1)+1:20*i;
        train_index = setdiff(1:100,test_index);
        train_data = [class1(:,train_index),class2(:,train_index)];  
        test_data = [class1(:,test_index),class2(:,test_index)];
        train_label =[label1(train_index),label2(train_index)];
        test_label = [label1(test_index),label2(test_index)];
        for n = 1:size(train_data,2)
            zeta(n)= max(1-train_label(n)*(W'*train_data(:,n)+ C),0)+0.001;
        end
        init_Z = [W',C,zeta];
        t = setPara.t;
        while t<setPara.Tmax
            [optSol,err]=solver_Newton(@function_cost,init_Z,lambda,t,train_data,train_label,setPara.tol);
            init_Z=optSol;
            t=t*15;
        end
        tmp_W = optSol(1:num)';
        tmp_C = optSol(num+1);  
        predict = tmp_W' * test_data +tmp_C;
        % If the prediction * label >0, they belong to the same class, thus the prediction is correct
        cor = cor + sum(predict.* test_label>=0);
    end
        Ac_interior(j) = cor;
    if cor > max_cor
        max_cor = cor;
        optLambda = lambda;
        %optSol = sol;
    end
end

for n = 1:size(X,2) % X is the complete given dataset
    zeta2(n)= max(1-Y(n)*(W'*X(:,n)+ C),0)+0.001;
end

t_2 = setPara.t;
Z_2 = [W',C,zeta2];

while (t_2 <= setPara.Tmax)
    [sol2, err] = solver_Newton(@function_cost,Z_2,optLambda,t_2,X,Y,setPara.tol);
     t_2 = 15*t_2;
     Z_2 = sol2;
end  
% Finally, give the sol2 (calculated on 200 datasets) to output-optSol
optSol=sol2;
end 





