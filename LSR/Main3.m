%%Calculating Training error
x = SmallData2(1,:);
y = SmallData2(2,:);
[~,k]= size(x);
n=9;
for lambda=[1.0e-06,0.001,1,1000,1.0e+06]
    %compute regularized coefficient
    coeff=Regularized_LSR_yl597(x,y,n,lambda);
    X=zeros(1,n+1);
    error=0;
    for count=1:k
        x0=x(count);
        y0=y(count);
        realData = y0;
        for i = 1:n+1
            X(1,i) = (x0)^(n+1-i);
        end
        trainedData = X*coeff;
        error0 = (trainedData-realData).^2;
        error=error+error0;
    end
    error=error/k;
    fprintf('Training error for N=9, lambda=%g is %g\n',lambda,error);
end

%%Calculating Testing error
a = TestData(1,:);
b = TestData(2,:);
[~,k]= size(x);
[~,num]= size(a);
n=9;
for lambda=[1.0e-06,0.001,1,1000,1.0e+06]
    %compute regularized coefficient
    coeff=Regularized_LSR_yl597(x,y,n,lambda);    
    X=zeros(1,n+1);
    error=0;
    for count=1:num
        x0=a(count);
        y0=b(count);
        realData = y0;
        for i = 1:n+1
            X(1,i) = (x0)^(n+1-i);
        end
        trainedData = X*coeff;
        error0 = (trainedData-realData).^2;
        error=error+error0;
    end
    error=error/num;
    fprintf('Testing error for N=9, lambda=%g is %g\n',lambda,error);
end
x1 = SmallData2(1,:);
y1 = SmallData2(2,:);
x2 = TestData(1,:);
y2 = TestData(2,:);
x3 = linspace(0,1,100);
coeff_train = Try2(x,y,9,0.000001);
%disp(coeff_train)
f1 = polyval(coeff_train,x3);
coeff_test = Try2(x,y,9,0.001);
%disp(coeff_test)
f2 = polyval(coeff_test,x3);
plot(x1,y1,'ro',x2,y2,'go',x3,f1,x3,f2)
xlabel("x");
ylabel("y");
legend("Train Data","Test Data","Model with Min Training error", "Model with Min Test error");