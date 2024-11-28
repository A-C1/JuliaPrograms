import numpy as np
import optimal_define as op
import rk_backward as rk_b
import system_define as syst
import dyn_sys_config as ds

no_inputs = ds.no_inputs


def trans_mat(x_tf, neu, tf, x0, psi_var, omega_var):
    
    # Concatenating vectors
    t_tmp = np.zeros((1,1))
    t_tmp[0,0] = tf
    guess_param = np.concatenate( (x_tf, neu, t_tmp) ) #Values that are guessed by us
    

    t_tmp[0,0] = omega_var
    reflect_param = np.concatenate( (x0, psi_var, omega_var)) #Values that are reflected because of our guess
    reflect_param_integ = reflect_param

    delta = 0.001 
    total_parameters = np.size(guess_param)
    delta_guess = np.zeros((total_parameters, 1))

    jacob = np.zeros((total_parameters, total_parameters))

    for i in range(total_parameters):
        guess_param[i, 0] += delta 
        tf_changed = guess_param[total_parameters-1, 0]
        psi_changed = op.psi(guess_param[:3,:]) 
        omega_changed = op.omega(guess_param[:3,:]

        [a, x0_calc, b] = rk_b.rk_back(syst.double_integrator, syst.input_double_integrator, t0, tf, h, no_inputs, xf, 's')

        guess_param[i, 0] -= delta
        reflect_param_integ = np.concatenate( (x0_calc, psi_changed, omega_changed ) )
        delta_guess = reflect_param_integ - reflect_param 
        jacob[:, i] = delta_guess / delta  

    print(jacob)
         















    





    
