clc;
clear all;
xe = 10; ye= 5; xp=0; yp=0; up=0; wp=0; ue=6; we=0; ae = 5; ap=10;

% for i=1:100
% A = csvread('input_data_inertia.csv',i, 0, [i 0 i 5]);
% xe = A(1);
% ye = A(2);
% xp = A(3);
% yp = A(4);
% up = A(5);
% wp = A(6);
% ue = A(7);
% we = A(8);
% ap = A(9);
% ae = A(10);

syms  t xc yc;


eq1 = (xc - xe - ue*t)^2 + (yc - ye - we*t)^2 - 0.5*ae^2*t^4;
eq2 = (xc - xp - up*t)^2 + (yc - yp - wp*t)^2  - 0.5*ap^2*t^4;
eq3 = yc*((up*t+xp) - (ue*t+xe)) + xc*(-(wp*t+yp) + (we*t+ye)) + (-(wp*t+yp)*(ue*t+xe)+(we*t+ye)*(up*t+xp));

eqns = [eq1==0, eq2 ==0, eq3 ==0];
S = solve(eqns, [t, xc, yc])
St = double(S.t)
idx = 1;
max = 0;
for i=1:length(St)
    if imag(St(i))==0 && St(i)>max
        idx = i;
        max = St(i);
    end
end

max
xc = double(S.xc(idx))
yc = double(S.yc(idx))

theta_p = atan2((yc - yp - wp*max), (xc - xp - up*max));
theta_e = atan2((yc - ye - we*max), (xc - xe - ue*max));
theta = [theta_p theta_e]
  


