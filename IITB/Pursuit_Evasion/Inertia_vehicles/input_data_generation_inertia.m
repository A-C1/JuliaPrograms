clc;
clear all;

xe_lin = linspace(-10,10,5);
ye_lin = linspace(-10,10,5);
xp_lin = linspace(-10,10,5);
yp_lin = linspace(-10,10,5);
up_lin = linspace(-10,10,5);
wp_lin = linspace(-10,10,5);
ue_lin = linspace(-10,10,5);
we_lin = linspace(-10,10,5);
ap_lin = linspace(0.1,10,5);
ae_lin = linspace(0.1,5,5);

[Xe, Ye, Xp, Yp, Up, Wp, Ue, We, Ap, Ae] = ndgrid(xe_lin,ye_lin,xp_lin,yp_lin,up_lin,wp_lin,ue_lin,we_lin,ap_lin,ae_lin);
points = [Xe(:) Ye(:) Xp(:) Yp(:) Up(:) Wp(:) Ue(:) We(:) Ap(:) Ae(:)];

csvwrite('input_data_inertia.csv',points);