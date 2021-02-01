% Yu Leng, yl597@duke.edu:
% Data: 2020-03-16


data = load('DataFeaImg.mat');

% initialize parameters
setPara.t = 1;
setPara.Tmax=1000000;
setPara.C = 0;
setPara.tol = 0.00001;%might also try others, like 0.1,0.001
Accu= zeros(1,6);
optLambdas = zeros(1,6);

% get class1 and class2
class1 = data.class{1,1};
class2 = data.class{1,2};
num = size(class1,1);

% 6-fold Cross-Validation
for i=1:6
    test_index = 20*(i-1)+1:20*i;
    train_index = setdiff(1:120,test_index); 
    train_X = [class1(:,train_index),class2(:,train_index)];  
    test_X = [class1(:,test_index),class2(:,test_index)];
    train_Y = [ones(1,100) -ones(1,100)]; 
    test_Y = [ones(1,20) -ones(1,20)];
    
    % Apply interior method
    setPara.W = (ones(1,num));
    [optSol, optlambda] = solver_interior(train_X,train_Y,setPara);
    W = optSol(1:num);
    C = optSol(num+1);
    
    % Apply to test data and calculate accuracy
    predict  = W * test_X + C; 
    acc = sum(test_Y.*predict>=0)/40; 
    Accu(i) = acc;
    
    % store the optlambda calculated in the solver_interior in optLambdas
    optLambdas(i) = optlambda;
    
    % Display W,C values, and show weights
    if i == 6
        disp('Values of W - most dominant values')
        sort_W = sort(abs(W),'descend');
        biggest_W = zeros(1,5);
        for index = 1:5
        posi = find(abs(W)==sort_W(index));
            biggest_W(index) = W(posi);
        end
        disp(biggest_W)
        disp('Values of C')
        disp(C)
        show_weights(abs(W));
    end
    
end

%Print results
disp('Accuracy of each fold')
disp(Accu)
disp('Best Lambda for each fold')
disp(optLambdas)
fprintf('The mean of accurary is %g\n',mean(Accu));
fprintf('The standard deviation of accuracy is %g\n',std(Accu));


