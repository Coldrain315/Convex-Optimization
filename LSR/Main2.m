%%Calculating Training error
x = LargeData2(1,:);
y = LargeData2(2,:);
[~,num] = size(x);
for power=1:9 
    coeff = LSR_yl597(x,y,power);
    X=zeros(1,power+1);
    error=0;
    for count=1:num
        x0=x(count);
        y0=y(count);
        realData = y0;
        for i = 1:power+1
            X(1,i) = (x0)^(power+1-i);
        end
        trainedData = X*coeff;
        error0 = (trainedData-realData).^2;
        error=error+error0;
    end
    error=error/num;
    fprintf('Training error for N=%g is %g\n',power,error);
end

a = TestData(1,:);
b = TestData(2,:);
[~,num] = size(a);
for power=1:9 
    coeff = LSR_yl597(x,y,power);
    X=zeros(1,power+1);
    error=0;
    for count=1:num
        x0=a(count);
        y0=b(count);
        realData = y0;
        for i = 1:power+1
            X(1,i) = (x0)^(power+1-i);
        end
        trainedData = X*coeff;
        error0 = (trainedData-realData).^2;
        error=error+error0;
    end
    error=error/num;
    fprintf('Testing error for N=%g is %g\n',power,error);
end
x1 = LargeData2(1,:);
y1 = LargeData2(2,:);
x2 = TestData(1,:);
y2 = TestData(2,:);
x3 = linspace(0,1,100);
coeff_train = LSR_yl597(x,y,9);
%disp(coeff_train)
f1 = polyval(coeff_train,x3);
coeff_test = LSR_yl597(x,y,5);
%disp(coeff_test)
f2 = polyval(coeff_test,x3);
plot(x1,y1,'ro',x2,y2,'go',x3,f1,x3,f2)
xlabel("x");
ylabel("y");
legend("Train Data","Test Data","Model with Min Training error", "Model with Min Test error");