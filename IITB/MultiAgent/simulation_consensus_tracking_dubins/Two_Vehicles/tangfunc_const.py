"""
Created on Wed Mar  7 11:13:12 2018

@author: Aditya Chaudhari
email: aditya2192@gmail.com

This file contains all the functions
required to implement the tangent law
described in the paper.
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import matplotlib.patches as patches

# Parameters for checking the working og the commands
# th = np.linspace(0, 2*np.pi, 359)

# r_A = 1
# x_A = 0
# y_A = 1

# r_B = 1
# x_B = 5
# y_B = 5

def tangfunc(x_A, y_A, r_A, x_B, y_B, r_B):
    """TODO: Return tangents between two circles.
    Since Tangents are straight lines they are defined by two points. In
    order to specify a tangent we specify two points, one on each circle.
    See the angles and their definition on Wikioedia.
    """
    # For actually drawing the circle. Not necessary
    # boundary_A = [x_A + r_A*np.cos(th), y_A + r_A*np.sin(th)]
    # boundary_B = [x_B + r_B*np.cos(th), y_B + r_B*np.sin(th)]

    # Ploting External tangents
    # Some angles to be calculated
    gamma = np.arctan2((y_B-y_A), (x_B-x_A))
    beta = np.arcsin((r_B-r_A)/np.sqrt((y_A-y_B)**2+(x_A-x_B)**2))
    alpha = -gamma-beta
    alpha2 = -gamma+beta

    # External Tangent 1
    xe1_A = x_A + r_A*np.cos(np.pi/2-alpha)
    ye1_A = y_A + r_A*np.sin(np.pi/2-alpha)
    xe1_B = x_B + r_B*np.cos(np.pi/2-alpha)
    ye1_B = y_B + r_B*np.sin(np.pi/2-alpha)

    # External Tangent 2
    xe2_A = x_A + r_A*np.cos(np.pi + (np.pi/2-alpha2))
    ye2_A = y_A + r_A*np.sin(np.pi + (np.pi/2-alpha2))
    xe2_B = x_B + r_B*np.cos(np.pi + (np.pi/2-alpha2))
    ye2_B = y_B + r_B*np.sin(np.pi + (np.pi/2-alpha2))


    # Ploting internal tangents
    # Some angles required in plotting of internal tangents
    gammai = np.arctan2((y_B-y_A),(x_B-x_A))
    betai = np.arcsin((r_B+r_A)/np.sqrt((y_A-y_B)**2+(x_A-x_B)**2))
    alphai = np.pi/2-gammai-betai
    alphai1 = np.pi/2+gammai-betai

    # Internal Tangent 1
    xi1_A = x_A + r_A*np.cos(alphai)
    yi1_A = y_A - r_A*np.sin(alphai)
    xi1_B = x_B - r_B*np.cos(alphai)
    yi1_B = y_B + r_B*np.sin(alphai)

    # Internal Tangent 2
    xi2_A = x_A + r_A*np.cos(alphai1)
    yi2_A = y_A + r_A*np.sin(alphai1)
    xi2_B = x_B - r_B*np.cos(alphai1)
    yi2_B = y_B - r_B*np.sin(alphai1)

    
    # Coordinates of each tangent are clubbed together
    te1 = np.array([[xe1_A,xe1_B], [ye1_A,ye1_B]])
    te2 = np.array([[xe2_A,xe2_B], [ye2_A,ye2_B]])
    ti1 = np.array([[xi1_A,xi1_B], [yi1_A,yi1_B]])
    ti2 = np.array([[xi2_A,xi2_B], [yi2_A,yi2_B]])


    return [te1, te2, ti1, ti2]


def acangle(v1, v2):
    """
    This function computes the anti-clockwise angle between two
    vectors in degrees.
    """
    theta2 = np.arctan2(v2[1], v2[0])
    theta1 = np.arctan2(v1[1], v1[0])
    if theta1 < 0:
        theta1 = 2*np.pi + theta1

    if theta2 < 0:
        theta2 = 2*np.pi + theta2

    theta = (theta2 - theta1)*180/np.pi

    if theta < 0:
        return theta + 360
    else:
        return theta


def calccenters(vp, up, z0p, ve, ue, z0e):
    """
    For the given initial positions calculate
    the pursuer and evader circles
    """

    rp = 1/up # Radius of pursuer circles
    # Anti Clockwise Circle of Pursuer
    xpa = z0p[0] - (1/up)*np.sin(z0p[2])
    ypa = z0p[1] + (1/up)*np.cos(z0p[2])

    # Clockwise Circle of Pursuer
    xpc = z0p[0] + (1/up)*np.sin(z0p[2])
    ypc = z0p[1] - (1/up)*np.cos(z0p[2])

    re = 1/ue # Radius of evader circles
    # Anti Clockwise Circle of Evader
    xea = z0e[0] - (1/ue)*np.sin(z0e[2])
    yea = z0e[1] + (1/ue)*np.cos(z0e[2])

    # Clockwise Circle of Evader
    xec = z0e[0] + (1/ue)*np.sin(z0e[2])
    yec = z0e[1] - (1/ue)*np.cos(z0e[2])

    return xpa, ypa, xpc, ypc, rp, xea, yea, xec, yec, re


def tang_dist(ta, pflag, xp_cen, yp_cen, rp, vp, xp, yp, eflag, xe_cen, ye_cen,
              re, ve, xe, ye):
    """
    ta: tangent under consideration, pflag:1: tangent to a-clock circle 0:
    tangent to clock circle. xp_cen : x-coordinate of pursuer circle under
    consideration, yp_cen : y-coordinate of evader circle under consideration,
    rp : radius of pursuer circle, vp: velocity of pursuer circle, xp: pursuer
    location x-coordinate, yp: pursuer location y coordinate....similar for the
    evader
    """

    # Calculations for checking validity. Here, the origin is moved
    # to the intersection of the tangent under consideration and the considered
    # pursuer circle or the evader circle
    # vtp=vte : vector of tangent from pursuer to evader
    # ploc : vector from tangent-pursuer circle intersection to pursuer
    # eloc : vector from tangent-evader circle intersection to pursuer
    xtp = ta[0, 1] - ta[0, 0]
    xte = xtp
    ytp = ta[1, 1] - ta[1, 0]
    yte = ytp
    vtp = np.array([xtp, ytp])
    vte = np.array([xte, yte])
    ploc = np.array([xp_cen-ta[0,0], yp_cen-ta[1,0]])
    eloc = np.array([xe_cen-ta[0,1], ye_cen-ta[1,1]])
    pang = acangle(ploc, vtp)
    eang = acangle(eloc, vte)

    # Calculaing the distance
    # vtp1: vector from pur cir center to tangent-purcircle intersection
    # vte1: vector from eva cir center to tangent-evacircle intersection
    xtp1 = ta[0,0] - xp_cen
    xte1 = ta[0,1] - xe_cen
    ytp1 = ta[1,0] - yp_cen
    yte1 = ta[1,1] - ye_cen
    vtp1 = np.array([xtp1, ytp1])
    vte1 = np.array([xte1, yte1])
    ploc1 = np.array([xp-xp_cen, yp-yp_cen]) # Pursuers location w.r.t cir-ce
    eloc1 = np.array([xe-xe_cen, ye-ye_cen])
    # Calculating the angle subtended by the directed arc on pursuer (evader)
    # circle from pursuer (evader) position to the tangent-purcircle
    # intersection.
    if pflag == 1:
        angle_p = acangle(ploc1, vtp1)
    else:
        angle_p = 360-acangle(ploc1, vtp1)

    if eflag == 1:
        angle_e = acangle(eloc1, vte1)
    else:
        angle_e = 360-acangle(eloc1, vte1)

    # Calculating the distance on the directed arc on pursuer (evader)
    # circle from pursuer (evader) position to the tangent-purcircle
    # intersection.
    dist_p = np.abs(rp*angle_p*np.pi/180)
    dist_e = np.abs(re*angle_e*np.pi/180)
    # distance from tangent-purcircle intersection to tangent-evacircle
    # intersection
    distance = np.linalg.norm(vtp) 
    # First we compare if evader or pursuer will come on to the tangent
    # earlier and using this we compute the time to capture
    if dist_e > dist_p:
        t1 = dist_e/ve
        dist1 = t1*vp
        dist2 = distance + dist_p - dist1
        time = t1 + dist2/(vp-ve)
    else:
        t1 = dist_e/ve
        dist1 = t1*vp
        dist2 = distance + dist_p + dist1
        time = t1 + dist2/(vp-ve)

    # Check if valid and if so print time
    # The various cases are for eac of the four pairs of circles
    # If the tangent is not valid the time is computed as infinity
    if pflag == 1 and eflag == 1:
        if pang <= 271 and  pang >= 269\
           and eang <= 271 and  eang >= 269:
            return time
        else:
            return np.inf
    if pflag == 1 and eflag == 0:
        if pang <= 271 and  pang >= 269\
           and eang <= 91 and  eang >= 89:
            return time
        else:
            return np.inf
    if pflag == 0 and eflag == 1:
        if pang <= 91 and  pang >= 89\
           and eang <= 271 and  eang >= 269:
            return time
        else:
            return np.inf
    if pflag == 0 and eflag == 0:
        if pang <= 91 and  pang >= 89\
           and eang <= 91 and  eang >= 89:
            return time
        else:
            return np.inf

def tang_group_dist(taa, pflag, xp_cen, yp_cen, rp, vp, xp, yp, eflag, xe_cen, ye_cen,
                    re, ve, xe, ye):
    """
    Just computes the times on all the tangents of a particular pair. Note that
    only one of the tangent will have finite time. All the others will have
    infinite time.
    """
    y = []
    for i in range(0,4):
        y.append([tang_dist(taa[i], pflag, xp_cen, yp_cen, rp, vp, xp, yp, eflag, xe_cen, ye_cen,
                           re, ve, xe, ye), i])
    return np.array(y)



def calc_dist(xa, ya, xb, yb):
    """
    Calculates distance between two points a and b
    xa and ya are the x and y coordinates of point a
    xb and yb are the x and y coordinates of point b
    """
    return np.linalg.norm(np.array([xb-xa,yb-ya]))




def saddle_points(matrix):
    """
    Calculates the saddle point of a 2*2 matrix
    """
    row_index = []
    col_index = []
    for i in range(0, 2):
        row_index.append(np.max(matrix[i, :]))
        col_index.append(np.min(matrix[:, i]))

    row_sel = np.argmin(row_index)
    col_sel = np.argmax(col_index)

    if col_sel == 0:
        col_sel = -1
    if row_sel == 0:
        row_sel = -1

    return row_sel, col_sel


def dec_matrix_input(tangents):
    """
    This function computes the 2*2 matrix
    with times along each valid tangent.
    Since, we are assigning inf value to 
    invalid tangents np.min selects the 
    correct valid time for each circle
    pair (since only the valid tangent will have
    finite time, np.min will select this tangent). 
    """
    dec_matrix = np.zeros([2,2])
    dec_matrix[0, 0] = np.min(tangents[0][:,0])
    dec_matrix[1, 0] = np.min(tangents[1][:,0])
    dec_matrix[0, 1] = np.min(tangents[2][:,0])
    dec_matrix[1, 1] = np.min(tangents[3][:,0])

    up, ue = saddle_points(dec_matrix)

    return up, ue, dec_matrix


def calc_input(vp, up, z0p, ve, ue, z0e):
    """
    This function computes the input. It is the function
    that both pursuer and evader will compute independently
    in order to decide their inputs. The function requires
    only the states of pursuer and evader and maximum values
    of turning rate and forward velocity.
    vp (ve): maximum forward velocity of pursuer (evader)
    up (ue): maximum turning rate of pursuer (evader)
    z0p (z0e): initial state of the pursuer (evader)
    """
    # Calculating the centers of circles
    [xpa, ypa, xpc, ypc, rp, xea, yea, xec, yec, re] = \
                                    calccenters(vp, up, z0p, ve, ue, z0e)

    # Calculating all the tangents
    taa = tangfunc(xpa, ypa, rp, xea, yea, re)
    tac = tangfunc(xpa, ypa, rp, xec, yec, re)
    tca = tangfunc(xpc, ypc, rp, xea, yea, re)
    tcc = tangfunc(xpc, ypc, rp, xec, yec, re)

    # Calculating times along all the tangents
    taa_dist = tang_group_dist(taa, 1, xpa, ypa, rp, vp, z0p[0], z0p[1], 1,
                               xea, yea, re, ve, z0e[0], z0e[1])
    tac_dist = tang_group_dist(tac, 1, xpa, ypa, rp, vp, z0p[0], z0p[1], 0,
                               xec, yec, re, ve, z0e[0], z0e[1])
    tca_dist = tang_group_dist(tca, 0, xpc, ypc, rp, vp, z0p[0], z0p[1], 1,
                               xea, yea, re, ve, z0e[0], z0e[1])
    tcc_dist = tang_group_dist(tcc, 0, xpc, ypc, rp, vp, z0p[0], z0p[1], 0,
                               xec, yec, re, ve, z0e[0], z0e[1])

    # Calculating the decision matrix
    tangents = [tcc_dist, tac_dist, tca_dist, taa_dist]
    up, ue, matrix = dec_matrix_input(tangents)

    return up, ue, matrix


def calc_input_los(vp, up, z0p, ve, ue, z0e):
    """
    This function calculates the inputs based on LOS law.
    In many cases the LOS law is sub-optimal. However, the 
    advantage of LOS law is that it requires very few 
    computaions and in many situations the trajectories
    coiincide with the tangent law
    """
    y_rel = z0e[1] - z0p[1] 
    x_rel = z0e[0] - z0p[0]
    los_vec = np.array([x_rel, y_rel]) # Line of sight vector
    x_axis = np.array([1, 0]) # vector pointing in positive x-axis dirction

    # Angle between x-axis and the LOS 
    los_angle = acangle(x_axis, los_vec) 

    # Relative angle between pursuer ande LOS and evader and LOS
    rel_angle_p = z0p[2]*180/np.pi - los_angle
    rel_angle_e = z0e[2]*180/np.pi - los_angle

    # The algorithm is simple and basically involves turning in direction
    # to allign quickely along LOS
    if rel_angle_p < 0 or rel_angle_p > 180:
        up = +1
    else:
        up = -1

    if rel_angle_e < 0 or rel_angle_e > 180:
        ue = +1
    else:
        ue = -1

    return up, ue


def tang_group_valid(taa, pflag, xp_cen, yp_cen, rp, vp, xp, yp, eflag, xe_cen, ye_cen,
                    re, ve, xe, ye):
    """
    Returns only the valid tangent in the group.
    This function is not used in actual program.
    """
    for i in range(0,4):
        y = tang_dist(taa[i], pflag, xp_cen, yp_cen, rp, vp, xp, yp, eflag, xe_cen, ye_cen,
                           re, ve, xe, ye)
        if y != np.inf:
            return taa[i]

# These are some functions which can be used for plotting various geometrical
# objects
def plot_circle(x, y, r):
    th = np.linspace(0, 2*np.pi, 359)
    boundary = [x + r*np.cos(th), y + r*np.sin(th)]
    plt.plot(boundary[0], boundary[1])


def plot_tangent(ta):
    plt.plot(ta[0], ta[1])


def plot_tangent_group(taa):
    plot_tangent(taa[0])
    plot_tangent(taa[1])
    plot_tangent(taa[2])
    plot_tangent(taa[3])


def valid_circles(vp,up,z0p,ve,ue,z0e):
    # Some heuristic Algorithm which does not give correct tangents
    # in all the cases. It depends on selecting the pursuer circle which 
    # is closest to the evader.
    [xpa, ypa, xpc, ypc, rp, xea, yea, xec, yec, re] = calccenters(vp,up,z0p,ve,ue,z0e)

    dist_pc = calc_dist(z0p[0], z0p[1], xec, yec)
    dist_pa = calc_dist(z0p[0], z0p[1], xea, yea)
    dist_ec = calc_dist(z0e[0], z0e[1], xpc, ypc)
    dist_ea = calc_dist(z0e[0], z0e[1], xpa, ypa)

    if dist_pc < dist_pa:
        ue = 1
    elif dist_pc > dist_pa:
        ue = -1
    else:
        ue = 0

    if dist_ec < dist_ea:
        up = -1
    elif dist_ec > dist_ea:
        up = 1
    elif dist_ec == dist_ea and z0p[2] != z0e[2]:
        up = 1
    else:
        up = 0

    return up, ue

def plot_reach(initial_state, v_max, u_max, figure_no, plus, minus, plus_minus,
        minus_plus, no_iter, T, dt):
    """
    Used to plot the reachable sets of the pursuer and the
    evader. 
    """
    x0 = initial_state[0]
    y0 = initial_state[1]
    theta0 = initial_state[2]

    vp = v_max
    up = u_max

    xf_plus = np.zeros([no_iter])
    yf_plus = np.zeros([no_iter])

    xf_minus = np.zeros([no_iter])
    yf_minus = np.zeros([no_iter])

    xf_plus_minus = np.zeros([no_iter])
    yf_plus_minus = np.zeros([no_iter])

    for i in range(0, no_iter):
        t1 = i*dt

        xf_plus[i] = x0 + (np.sin(theta0 + vp*up*t1) - np.sin(theta0))/up + vp*np.cos(theta0 + vp*up*t1)*(T - t1)
        yf_plus[i] = y0 - (np.cos(theta0 + vp*up*t1) - np.cos(theta0))/up + vp*np.sin(theta0 + vp*up*t1)*(T - t1)

        xf_minus[i] = x0 - (np.sin(theta0 - vp*up*t1) - np.sin(theta0))/up + vp*np.cos(theta0 - vp*up*t1)*(T - t1)
        yf_minus[i] = y0 + (np.cos(theta0 - vp*up*t1) - np.cos(theta0))/up + vp*np.sin(theta0 - vp*up*t1)*(T - t1)
    
        xf_plus_minus[i] = x0 + (np.sin(theta0 + up*t1) - np.sin(theta0))/up  - (np.sin(theta0 + up*t1 - up*(T-t1)) - np.sin(theta0 +
                                                                                                                         up*t1))/up
        yf_plus_minus[i] = y0 - (np.cos(theta0 + up*t1) - np.cos(theta0))/up  + (np.cos(theta0 + up*t1 - up*(T-t1)) -
                                                                             np.cos(theta0 + up*t1))/up
    plt.figure(figure_no)
    plt.axis('equal')
    if plus == 1:
        plt.plot(xf_plus, yf_plus)
    if minus == 1:
        plt.plot(xf_minus, yf_minus)
    if plus_minus == 1:
        plt.plot(xf_plus_minus, yf_plus_minus)






