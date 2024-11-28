clc;
clear all;

xe_lin = linspace(-10,10,5);
ye_lin = linspace(-10,10,5);
xp_lin = linspace(-10,10,5);
yp_lin = linspace(-10,10,5);
vp_lin = linspace(5.1,10,5);
ve_lin = linspace(0.1,5,5);

[Xe, Ye, Xp, Yp, Vp, Ve] = ndgrid(xe_lin,ye_lin,xp_lin,yp_lin,vp_lin,ve_lin);
points = [Xe(:) Ye(:) Xp(:) Yp(:) Vp(:) Ve(:)];

csvwrite('input_data.csv',points);