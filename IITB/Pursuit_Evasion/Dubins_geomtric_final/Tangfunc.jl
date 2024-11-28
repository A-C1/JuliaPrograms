module Tangfunc
using CairoMakie, LinearAlgebra
using BenchmarkTools

# Parameters for checking the working og the commands
th = LinRange(0, 2*pi, 359)

ra = 2
xa = 0
ya = 1

rb = 1
xb = 5
yb = 5

function plot_circle(x, y, r, plt)
    th = LinRange(0, 2*pi, 359)
    boundary = [x .+ r*cos.(th), y .+ r*sin.(th)]
    # display(plot!(plt, boundary[1], boundary[2], aspectratio=1))
end

# fig1 = plot(legend = false)
# plot_circle(xa, ya, ra, fig1)
# plot_circle(xb, yb, rb, fig1)

function tangfunc(x_A, y_A, r_A, x_B, y_B, r_B)
    """TODO: Return tangents between two circles.
    Since Tangents are straight lines they are defined by two points. In
    order to specify a tangent we specify two points, one on each circle.
    See the angles and their definition on Wikipedia.
    """

    # Ploting External tangents
    # Some angles to be calculated
    gamma = atan((y_B-y_A), (x_B-x_A))
    beta = asin((r_B-r_A)/sqrt((y_A-y_B)^2+(x_A-x_B)^2))
    alpha = -gamma-beta
    alpha2 = -gamma+beta

    # External Tangent 1
    xe1_A = x_A + r_A*cos(pi/2-alpha)
    ye1_A = y_A + r_A*sin(pi/2-alpha)
    xe1_B = x_B + r_B*cos(pi/2-alpha)
    ye1_B = y_B + r_B*sin(pi/2-alpha)

    # External Tangent 2
    xe2_A = x_A + r_A*cos(pi + (pi/2-alpha2))
    ye2_A = y_A + r_A*sin(pi + (pi/2-alpha2))
    xe2_B = x_B + r_B*cos(pi + (pi/2-alpha2))
    ye2_B = y_B + r_B*sin(pi + (pi/2-alpha2))

if ((r_B+r_A) < sqrt((y_A-y_B)^2+(x_A-x_B)^2))
    # Ploting internal tangents
    # Some angles required in plotting of internal tangents
    gammai = atan((y_B-y_A),(x_B-x_A))
    betai = asin((r_B+r_A)/sqrt((y_A-y_B)^2+(x_A-x_B)^2))
    alphai = pi/2-gammai-betai
    alphai1 = pi/2+gammai-betai

    # Internal Tangent 1
    xi1_A = x_A + r_A*cos(alphai)
    yi1_A = y_A - r_A*sin(alphai)
    xi1_B = x_B - r_B*cos(alphai)
    yi1_B = y_B + r_B*sin(alphai)

    # Internal Tangent 2
    xi2_A = x_A + r_A*cos(alphai1)
    yi2_A = y_A + r_A*sin(alphai1)
    xi2_B = x_B - r_B*cos(alphai1)
    yi2_B = y_B - r_B*sin(alphai1)

    ti1 = [xi1_A xi1_B; yi1_A yi1_B]
    ti2 = [xi2_A xi2_B; yi2_A yi2_B]
else
    ti1 = [Inf Inf; Inf Inf]
    ti2 = [Inf Inf; Inf Inf]
end


    # Coordinates of each tangent are clubbed together
    te1 = [xe1_A xe1_B; ye1_A ye1_B]
    te2 = [xe2_A xe2_B; ye2_A ye2_B]


    return [te1, te2, ti1, ti2]
end

ta_grp = tangfunc(xa, ya, ra, xb, yb, rb)

# function plot_tangent(ta, plt)
#     display(plot!(plt, ta[1,:], ta[2,:]))
# end


# function plot_tangent_group(taa, plt)
#     plot_tangent(taa[1], plt)
#     plot_tangent(taa[2], plt)
#     plot_tangent(taa[3], plt)
#     plot_tangent(taa[4], plt)
# end

# plot_tangent_group(ta_grp, fig1)

function acangle(v1, v2)
    """This function computes the anti-clockwise angle between two
    vectors in degrees."""
    theta2 = atan(v2[2], v2[1])
    theta1 = atan(v1[2], v1[1])
    if theta1 < 0
        theta1 = 2*pi + theta1
    end

    if theta2 < 0
        theta2 = 2*pi + theta2
    end

    theta = (theta2 - theta1)*180.0/pi

    if theta < 0
        return theta + 360.
    else
        return theta
    end
end


function calccenters(vp, up, z0p, ve, ue, z0e)
    """
    For the given initial positions calculate
    the pursuer and evader circles
    """

    rp = 1/up # Radius of pursuer circles
    # Anti Clockwise Circle of Pursuer
    xpa = z0p[1] - (1/up)*sin(z0p[3])
    ypa = z0p[2] + (1/up)*cos(z0p[3])

    # Clockwise Circle of Pursuer
    xpc = z0p[1] + (1/up)*sin(z0p[3])
    ypc = z0p[2] - (1/up)*cos(z0p[3])

    re = 1/ue # Radius of evader circles
    # Anti Clockwise Circle of Evader
    xea = z0e[1] - (1/ue)*sin(z0e[3])
    yea = z0e[2] + (1/ue)*cos(z0e[3])

    # Clockwise Circle of Evader
    xec = z0e[1] + (1/ue)*sin(z0e[3])
    yec = z0e[2] - (1/ue)*cos(z0e[3])

    return xpa, ypa, xpc, ypc, rp, xea, yea, xec, yec, re

end

# (xpa, ypa, xpc, ypc, rp, xea, yea, xec, yec, re) = calccenters(vp, up, z0p, ve, ue, z0e)
# fig2 = plot(legend = false)

# plot_circle(xpa, ypa, rp, fig2)
# plot_circle(xpc, ypc, rp, fig2)
# plot_circle(xea, yea, re, fig2)
# plot_circle(xec, yec, re, fig2)

# ta_grp1 = tangfunc(xpa, ypa, rp, xea, yea, re)
# ta_grp2 = tangfunc(xpa, ypa, rp, xec, yec, re)
# ta_grp3 = tangfunc(xpc, ypc, rp, xea, yea, re)
# ta_grp4 = tangfunc(xpc, ypc, rp, xec, yec, re)

# plot_tangent_group(ta_grp3, fig2)

function tang_dist(ta, pflag, xp_cen, yp_cen, rp, vp, xp, yp, eflag, xe_cen, ye_cen,
    re, ve, xe, ye)
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
    xtp = ta[1, 2] - ta[1, 1]
    xte = xtp
    ytp = ta[2, 2] - ta[2, 1]
    yte = ytp
    vtp = [xtp; ytp]
    vte = [xte; yte]
    ploc = [xp_cen-ta[1,1]; yp_cen-ta[2,1]]
    eloc = [xe_cen-ta[1,2]; ye_cen-ta[2,2]]
    # println(ploc," ", eloc)
    pang = acangle(ploc, vtp)
    eang = acangle(eloc, vte)

    # Calculaing the distance
    # vtp1: vector from pur cir center to tangent-purcircle intersection
    # vte1: vector from eva cir center to tangent-evacircle intersection
    xtp1 = ta[1,1] - xp_cen
    xte1 = ta[1,2] - xe_cen
    ytp1 = ta[2,1] - yp_cen
    yte1 = ta[2,2] - ye_cen
    vtp1 = [xtp1; ytp1]
    vte1 = [xte1; yte1]
    ploc1 = [xp-xp_cen; yp-yp_cen] # Pursuers location w.r.t cir-ce
    eloc1 = [xe-xe_cen; ye-ye_cen]
    # Calculating the angle subtended by the directed arc on pursuer (evader)
    # circle from pursuer (evader) position to the tangent-purcircle
    # intersection.
    if pflag == 1
        angle_p = acangle(ploc1, vtp1)
    else
        angle_p = 360-acangle(ploc1, vtp1)
    end

    if eflag == 1
        angle_e = acangle(eloc1, vte1)
    else
        angle_e = 360-acangle(eloc1, vte1)
    end

    # Calculating the distance on the directed arc on pursuer (evader)
    # circle from pursuer (evader) position to the tangent-purcircle
    # intersection.
    dist_p = abs(rp*angle_p*pi/180)
    dist_e = abs(re*angle_e*pi/180)
    # distance from tangent-purcircle intersection to tangent-evacircle
    # intersection
    distance = norm(vtp)
    # First we compare if evader or pursuer will come on to the tangent
    # earlier and using this we compute the time to capture
    # if dist_e > dist_p
    #     t1 = dist_e/ve
    #     dist1 = t1*vp
    #     dist2 = distance + dist_p - dist1
    #     time = t1 + dist2/(vp-ve)
    # else
    #     t1 = dist_e/ve
    #     dist1 = t1*vp
    #     dist2 = distance + dist_p + dist1
    #     time = t1 + dist2/(vp-ve)
    # end
    time = distance + dist_p - dist_e
    # Check if valid and if so print time
    # The various cases are for eac of the four pairs of circles
    # If the tangent is not valid the time is computed as infinity
    if pflag == 1 && eflag == 1
        # println(pang,"  ",eang)
        if (pang <= 271 &&  pang >= 269 && eang <= 271 && eang >= 269)
            return time
        else
            return Inf
        end
    end

    if pflag == 1 && eflag == 0
        if (pang <= 271 && pang >= 269 && eang <= 91 && eang >= 89)
            return time
        else
            return Inf
        end
    end

    if pflag == 0 && eflag == 1
        if (pang <= 91 && pang >= 89 && eang <= 271 && eang >= 269)
            return time
        else
            return Inf
        end
    end

    if pflag == 0 && eflag == 0
        if pang <= 91 && pang >= 89 && eang <= 91 && eang >= 89
            return time
        else
            return Inf
        end
    end
end


function tang_group_dist(taa, pflag, xp_cen, yp_cen, rp, vp, xp, yp, eflag, xe_cen, ye_cen,
    re, ve, xe, ye)
    """
    Just computes the times on all the tangents of a particular pair. Note that
    only one of the tangent will have finite time. All the others will have
    infinite time.
    """
    y = []
    for i=1:4
        temp = tang_dist(taa[i], pflag, xp_cen, yp_cen, rp, vp, xp, yp, eflag, xe_cen, ye_cen,
        re, ve, xe, ye)
        push!(y, temp)
    end
    return minimum(y)
end

# dist = tang_group_dist(ta_grp4, 0, xpc, ypc, rp, vp, z0p[1], z0p[2], 0, xec, yec,
#                         re, ve, z0e[1], z0e[2])



function calc_dist(xa, ya, xb, yb)
    """
    Calculates distance between two points a and b
    xa and ya are the x and y coordinates of point a
    xb and yb are the x and y coordinates of point b
    """
    return norm([xb-xa; yb-ya])
end




function saddle_points(matrix)
    """
    Calculates the saddle point of a 2*2 matrix
    """
    row_index = []
    col_index = []
    for i=1:2
        push!(row_index, maximum(matrix[i, :]))
        push!(col_index, minimum(matrix[:, i]))
    end

    row_sel = argmin(row_index)
    col_sel = argmax(col_index)

    ue, up = 1, 1

    if col_sel == 1
        ue = -1
    elseif col_sel == 2
        ue = 1
    end

    if row_sel == 1
        up = -1
    elseif row_sel == 2
        up = 1
    end

    return up, ue
end

function dec_matrix_input(tang)
    dec_matrix = zeros(2,2)
    dec_matrix[1, 1] = tang[1]
    dec_matrix[2, 1] = tang[2]
    dec_matrix[1, 2] = tang[3]
    dec_matrix[2, 2] = tang[4]

    # print(dec_matrix)

    up, ue = saddle_points(dec_matrix)

    return up, ue, dec_matrix
end


function calc_input(vp, up, z0p, ve, ue, z0e)
    # Calculating the centers of circles
    (xpa, ypa, xpc, ypc, rp, xea, yea, xec, yec, re) = calccenters(vp,
    up, z0p, ve, ue, z0e)

    # Calculating all the tangents
    taa = tangfunc(xpa, ypa, rp, xea, yea, re)
    tac = tangfunc(xpa, ypa, rp, xec, yec, re)
    tca = tangfunc(xpc, ypc, rp, xea, yea, re)
    tcc = tangfunc(xpc, ypc, rp, xec, yec, re)

    # Calculating times along all the tangents
    taa_dist = tang_group_dist(taa, 1, xpa, ypa, rp, vp, z0p[1], z0p[2], 1,
    xea, yea, re, ve, z0e[1], z0e[2])
    tac_dist = tang_group_dist(tac, 1, xpa, ypa, rp, vp, z0p[1], z0p[2], 0,
    xec, yec, re, ve, z0e[1], z0e[2])
    tca_dist = tang_group_dist(tca, 0, xpc, ypc, rp, vp, z0p[1], z0p[2], 1,
    xea, yea, re, ve, z0e[1], z0e[2])
    tcc_dist = tang_group_dist(tcc, 0, xpc, ypc, rp, vp, z0p[1], z0p[2], 0,
    xec, yec, re, ve, z0e[1], z0e[2])

    # Calculating the decision matrix
    tangents = [tcc_dist, tac_dist, tca_dist, taa_dist]

    dec_matrix = zeros(2,2)
    dec_matrix[1, 1] = tangents[1]
    dec_matrix[2, 1] = tangents[2]
    dec_matrix[1, 2] = tangents[3]
    dec_matrix[2, 2] = tangents[4]

    # print(dec_matrix)

    up, ue = saddle_points(dec_matrix)

    return up, ue, dec_matrix
end

vp = 2.0; up=2.0; z0p = [0; 0; pi/2]
ve = 1.0; ue=1.0; z0e = [0; 10; -pi/2]


function calc_input_los(vp, up, z0p, ve, ue, z0e)
    """
    This function calculates the inputs based on LOS law.
    In many cases the LOS law is sub-optimal. However, the
    advantage of LOS law is that it requires very few
    computaions and in many situations the trajectories
    coiincide with the tangent law
    """
        y_rel = z0e[2] - z0p[2]
        x_rel = z0e[1] - z0p[1]
        los_vec = [x_rel; y_rel] # Line of sight vector
        x_axis = [1; 0] # vector pointing in positive x-axis dirction

        # Angle between x-axis and the LOS
        los_angle = acangle(x_axis, los_vec)

        # Relative angle between pursuer ande LOS and evader and LOS
        rel_angle_p = z0p[3]*180/pi - los_angle
        rel_angle_e = z0e[3]*180/pi - los_angle

        # The algorithm is simple and basically involves turning in direction
        # to allign quickely along LOS
        if rel_angle_p < 0 || rel_angle_p > 180
            up = +1
        else
            up = -1
        end

        if rel_angle_e < 0 || rel_angle_e > 180
            ue = +1
        else
            ue = -1
        end

        return up, ue
end

@btime u1, u2, mat = calc_input(vp, up, z0p, ve, ue, z0e)
# println(mat)

#         function tang_group_valid(taa, pflag, xp_cen, yp_cen, rp, vp, xp, yp, eflag, xe_cen, ye_cen,
#             re, ve, xe, ye)
#             """
#             Returns only the valid tangent in the group.
#             This function is not used in actual program.
#                 """
#                 for i=1:4
#                     y = tang_dist(taa[i], pflag, xp_cen, yp_cen, rp, vp, xp, yp, eflag, xe_cen, ye_cen,
#                     re, ve, xe, ye)
#                     if y != Inf
#                         return taa[i]
#                     end
#                 end
#             end
#
#
#             # These are some functions which can be used for plotting various geometrical
#             # objects
#
#
#
#
#             function valid_circles(vp,up,z0p,ve,ue,z0e)
#                 # Some heuristic Algorithm which does not give correct tangents
#                 # in all the cases. It depends on selecting the pursuer circle which
#                 # is closest to the evader.
#                 (xpa, ypa, xpc, ypc, rp, xea, yea, xec, yec, re) = calccenters(vp,up,z0p,ve,ue,z0e)
#
#                 dist_pc = calc_dist(z0p[1], z0p[2], xec, yec)
#                 dist_pa = calc_dist(z0p[1], z0p[2], xea, yea)
#                 dist_ec = calc_dist(z0e[1], z0e[2], xpc, ypc)
#                 dist_ea = calc_dist(z0e[1], z0e[2], xpa, ypa)
#
#                 if dist_pc < dist_pa
#                     ue = 1
#                 elseif dist_pc > dist_pa
#                     ue = -1
#                 else
#                     ue = 0
#                 end
#
#                 if dist_ec < dist_ea
#                     up = -1
#                 elseif dist_ec > dist_ea
#                     up = 1
#                 elseif dist_ec == dist_ea && z0p[2] != z0e[2]
#                     up = 1
#                 else
#                     up = 0
#                 end
#
#                 return up, ue
#
#             end
#
#             function plot_reach(initial_state, v_max, u_max, figure_no, plus, minus, plus_minus,
#             minus_plus, no_iter, T, dt):
#             x0 = initial_state[1]
#             y0 = initial_state[2]
#             theta0 = initial_state[3]
#
#             vp = v_max
#             up = u_max
#
#             xf_plus = zeros(no_iter)
#             yf_plus = zeros(no_iter)
#
#             xf_minus = zeros(no_iter)
#             yf_minus = zeros(no_iter)
#
#             xf_plus_minus = zeros(no_iter)
#             yf_plus_minus = zeros(no_iter)
#
#             for i=1:no_iter
#             t1 = i*dt
#
#             xf_plus[i] = x0 + (sin(theta0 + vp*up*t1) - sin(theta0))/up + vp*cos(theta0 + vp*up*t1)*(T - t1)
#             yf_plus[i] = y0 - (cos(theta0 + vp*up*t1) - cos(theta0))/up + vp*sin(theta0 + vp*up*t1)*(T - t1)
#
#             xf_minus[i] = x0 - (sin(theta0 - vp*up*t1) - sin(theta0))/up + vp*cos(theta0 - vp*up*t1)*(T - t1)
#             yf_minus[i] = y0 + (cos(theta0 - vp*up*t1) - cos(theta0))/up + vp*sin(theta0 - vp*up*t1)*(T - t1)
#
#             xf_plus_minus[i] = x0 + (sin(theta0 + up*t1) - sin(theta0))/up  - (sin(theta0 + up*t1 - up*(T-t1)) - sin(theta0 + up*t1))/up
#             yf_plus_minus[i] = y0 - (cos(theta0 + up*t1) - cos(theta0))/up  + (cos(theta0 + up*t1 - up*(T-t1)) - cos(theta0 + up*t1))/up
#
#             figure(figure_no)
#             if plus == 1
#             plot(xf_plus, yf_plus, axis = :equal)
#         end
#         if minus == 1
#         plot(xf_minus, yf_minus, axis = :equal)
#     end
#     if plus_minus == 1
#     plot(xf_plus_minus, yf_plus_minus, axis = :equal)
# end
# end
end
