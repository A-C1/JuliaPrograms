clc;
clear all;
xe = 5; ye=0; xp=0; yp=0; up=0; wp=0; ue=0; we=10; ae =1; ap=2;

% % for i=1:100
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

syms  t ce se cp sp xc yc;


eq1 = xc - xe - ue*t - ae*t*t*ce;
eq2 = yc - ye - we*t - ae*t*t*se;
eq3 = xc - xp - up*t - ap*t*t*cp;
eq4 = yc - yp - wp*t - ap*t*t*sp;

eq5 = ce^2 + se^2 - 1;
eq6 = cp^2 + sp^2 - 1;

eq7 = yc*((up*t+xp) - (ue*t+xe)) + xc*(-(wp*t+yp) + (we*t+ye)) + (-(wp*t+yp)*(ue*t+xe)+(we*t+ye)*(up*t+xp));

eqns = [eq1==0, eq2 ==0, eq3 ==0, eq4==0,eq5==0,eq6==0, eq7==0];
S = vpasolve(eqns, [t, ce, se, cp, sp, xc, yc]);
St = double(S.t);
idx = 1;
max = 0;
for i=1:8
    if imag(St(i))==0 && St(i)>max
        idx = i;
        max = St(i);
    end
end
S.t
[max idx]  
input = [xe ye xp yp up ue wp we ap ae];
output = double([S.xc(idx) S.yc(idx)])

theta_p = asin(S.sp(idx))*(180/pi)
theta_e = asin(S.se(idx))*(180/pi)
% csvwrite('output_data.csv',output,i,0);
% end

