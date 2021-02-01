function [coeff]=Regularized_LSR_yl597(x,y,n,lambda)
[~,k]= size(x);
    A=zeros(k+n+1,n+1);
    for k0=1:k          
        for n0=1:n+1
            A(k0,n0)=x(k0)^(n+1-n0);
        end
    end
    for k0=k+1:k+n+1
        A(k0,k0-k)= lambda^(1/2);
    end
    B = zeros(1,k+n+1);
    for i=1:k
        B(1,i)=y(i);
    end
    B=transpose(B);
    coeff = A\B;
end