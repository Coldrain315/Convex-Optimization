%1.ѭ����ʽ����A����
%2.A\B�õ�coefficient
function [coefficient]=LSR(x,y,n)
[~,k]=size(x);
    A=zeros(k,n+1);
    for k0=1:k           %�������X0L
        for n0=1:n+1
            A(k0,n0)=x(k0)^(n+1-n0);
        end
    end
    B = transpose(y);
    coefficient = A\B;
end
    
