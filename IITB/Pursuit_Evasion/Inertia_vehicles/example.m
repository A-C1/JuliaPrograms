addpath('/home/aditya/PHClab')
set_phcpath('/home/aditya/PHClab/phc')
t = [1.3 2 0; 4.7 0 2; -3.1 + 2.3*i 0 0; 0 0 0;
2.1 0 2; -1.9 1 0 ; 0 0 0];
make_system(t)
% shows symbolic format of the system
s = solve_system(t);
% call the blackbox solver
ns = size(s,2)
% check the number of solutions
s3 = s(3)
s3.x1
s3.x2
% look at the 3rd solution