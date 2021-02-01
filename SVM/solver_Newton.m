function [optSol, err] = solver_Newton(function_cost,init_Z,lambda,t,X,Y,tol)
% Solve the optimization problem using Newton method
%
% INPUTS:
%   function_cost: Function handle of F(Z)
%   init_Z: Initial value of Z
%   tol: Tolerance
%
% OUTPUTS:
%   optSol: Optimal soultion
%   err: Error
%
% @Yu Leng, yl597@duke.edu
% Data: 2020-03-16

% Initialize Z
% Set the error 2*tol to make sure the loop runs at least once


Z_1 = init_Z;
Z_0 = Z_1;
err = 1;

while (err/2) > tol
    % Execute the cost function at the current iteration
    [F, G, H] = feval(function_cost,Z_1, X, Y, lambda,t);
    delta= - H\G;        % inv(H) * G => H\G
    err = G'/H * G ;  % G' * inv(H) => G'/ H 
    % Backtrack line search
    s=1;
    while true
        % update Z_0
        Z_0 = Z_1 + s * delta';
        count = 0;
        for i = 1:size(X,2)
            if ((Z_0(1:204)*X(:,i))*Y(i)+Z_0(205)*Y(i)+Z_0(205+i)-1<=0)||(Z_0(205+i)<=0)
               count = count+1;
               break
            end
        end
        
        if count ==0
            break
        else
          s = 0.5 *s;
        end
    end
    % Update Z
    Z_1 = Z_0;
    optSol = Z_1;
end






