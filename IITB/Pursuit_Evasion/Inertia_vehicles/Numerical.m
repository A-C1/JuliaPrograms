clc;
clear all;
% xe =0; ye=0; xp=0; yp=0; vp=0; ve=0; 

for i=0:0
    A = csvread('input_data.csv',i, 0, [i 0 i 5]);
    xe = A(1);
    ye = A(2);
    vp = A(5);
    ve = A(6); 

    syms  t xc yc ce se cp sp;

    eq1 = xc - (xe + ve*t*ce);
    eq2 = yc - (ye + ve*t*se);
    eq3 = xc - (xp + vp*t*cp);
    eq4 = yc - (yp + vp*t*sp);

    eq5 = ce^2 + se^2 - 1;
    eq6 = cp^2 + sp^2 - 1;


    eq7 = (xc-xe)*(yc-yp)-(xc-xp)*(yc-ye);


    eqns = [eq1==0, eq2 ==0, eq3 ==0, eq4==0, eq5==0, eq6==0, eq7==0];

    S = solve(eqns, [t, xc, yc, ce, se, cp, sp]);
    St = double(S.t);
    idx = 1;
    max = 0;
    for j = 1:length(St)
        if imag(St(j))==0 && St(j)>max
            idx = j;
            max = St(j);
        end
    end
    input = [xe ye xp yp vp ve];
    %output(i,:) = double([S.xc(idx) S.yc(idx)]);
    output = double([S.xc(idx) S.yc(idx)]);
  

end

%csvwrite('output_data.csv',output,0,0);
