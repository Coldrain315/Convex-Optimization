function [F, G, H] = function_cost(Z, X, Y, Lambda, t)
% Compute the cost function F(Z)
%
% INPUTS: 
%   Z: Parameter values
%   X: Features
%   Y: Labels
%   Lambda and t: hyper-parameter in the object function
%
% OUTPUTS
%   F: Function value
%   G: Gradient value
%   H: Hessian value
%
% @Yu Leng, yl597@duke.edu:
% Data: 2020-03-16

% Initialize parameters
N=size(Z,2); 
nums_of_features = size(X,1);
nums_of_trials = size(X,2);
W=Z(1:204);
C=Z(205);
zeta=Z(206:N);

% Function F : 1*1
sum_zeta=sum(zeta);
A=W*X.*Y+C.*Y+zeta-1; %common part
sum_log_zeta=1/t*sum(log10(zeta));
F = sum_zeta+Lambda*(W'*W)-1/t*sum(log10(A))-sum_log_zeta;

% Gradient G : N*1
B=W*X.*Y+C.*Y+zeta-1;
G_log_common=log(10)*B;
d_W=2*Lambda*W'-1/t*sum((X.*Y)./G_log_common,2);
d_C=-1/t*sum(Y./G_log_common);
d_zeta=1-(1/t)*1./G_log_common-(1/t)*1./(log(10)*zeta);
% Put d_W, d_C and d_zeta together to the G, and make G vertical
G=[d_W',d_C,d_zeta]';


%
%
% Hessian Matrix H : N*N 
% split into 6 sections 
% Initialize Hessian Matrix
H = zeros(N,N);
log10t = 1/(t*log(10)); 

%calculate the sections separately and inssert them into Hessian matrix
% partial_sum_WW = zeros(nums_of_features,nums_of_features);
H_WW=eye(nums_of_features)*2*Lambda+log10t *(X.*Y./B*(X.*Y./B)');
H(1:204,1:204) = H_WW;
%H_WW= log10t* sum(X.*X.*Y.*Y./T.^2,2);

% H_WC and H_CW they are symmetric
H_WC =log10t*sum((X.*(Y.*Y))./B.^2,2);
H_CW = H_WC';
H(1:204,205) = H_WC;
H(205,1:204) = H_CW;

% H_Wzeta and H_zetaW are symmetric
H_Wzeta=log10t*((X.*Y)./B.^2);
H_zetaW = H_Wzeta';
H(1:204,206:end)=H_Wzeta;
H(206:end,1:204)=H_zetaW;

H_CC =log10t*sum(Y.^2./B.^2);
H(205,205) = H_CC;

H_Czeta =log10t*Y./B.^2;
H_Czeta_1 = H_Czeta;
H(205,206:end) = H_Czeta;
H(206:end,205) = H_Czeta_1;

H_zetazeta=eye(nums_of_trials)*log10t.*(1./B.^2+1./(zeta.^2));
H(206:end,206:end) = H_zetazeta;








