classdef setPara
    properties 
        t
        zeta
        Tmax
        tol
        W
        C
    end
    methods
        function obj = setPara(t,zeta,Tmax,tol,W,C)
            obj.t = t;
            obj.zeta = zeta;
            obj.Tmax = Tmax;
            obj.tol = tol;
            obj.W = W;
            obj.C = C;
        end 
    end
end