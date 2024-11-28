using Polynomials

function dyn_p(v, w, u, ap)
    xp = [v, ap*cos(u), w, ap*sin(u)]
    return xp 
end

function dyn_e(v, w, u, ae)
    xe = [v, ae*cos(u), w, ae*sin(u)]
    return xe
end

function solve_theta(xp, vp, yp, wp, xe, ve, ye, we, ap, ae)
    x = xe - xp
    y = ye - yp
    v = vp - ve
    w = wp - we
    a = ap - ae

    alpha = a^2/4
    A = (v^2 + w^2)/alpha
    B = (2*v*x+2*w*y)/alpha
    C = (x^2 + y^2)/alpha

    P = Polynomial(reverse([1.0 + 0.0im, 0.0 + 0.0im, -A+0im, B+0im, -C + 0im]))
    St::Vector{ComplexF64} = roots(P)
    #St = depressed_quartic(-A, B, -C)
    min_T = Inf
    for i=1:Int(length(St))
        if abs(imag(St[i]))<=1e-5 && real(St[i])<min_T && real(St[i])>0
            min_T = real(St[i])
        end
    end
    T = min_T
    theta = atan(y-w*T, x-v*T)
    return theta
end



# function solve_cubic(a, b, c, d)
# p = (3*a*c-b^2)/(3*a^2)
# q = (2*b^3 - 9*a*b*c + 27*a^2*d)/(27*a^3)
# x1 = depressed_cubic(p, q)
# x = x1 - b/(3*a)
# return [x]
# end
#
# function depressed_cubic(p, q)
# D = 27*q^2 + 4*p^3
# delta = sqrt(q^2/4+p^3/27)
# x1 = -q/2 + delta
# if D .> 0
#     x2 = -q/2 - delta
#     x = nthroot[x1,3] + nthroot[x2,3]
# else()
#     C = x1^(1/3)
#     x = C - p/(3*C)
# end
#
# return [x]
# end
#
# function depressed_quartic(A, B, C)
# # A
# # B
# # C
# s = cubic[-(4*A)/8, -8*C/8, (4*A*C-B*B)/8]
# # s = solve_cubic(8, -4*A, -8*C, 4*A*C-B*B)
#
# delta_1 = -2*s - A + 2*B/sqrt(2*s-A)
# delta_2 = -2*s - A - 2*B/sqrt(2*s-A)
# delta = sqrt(2*s-A)/2
# y1 = -delta + 0.5*sqrt(delta_1)
# y2 = -delta - 0.5*sqrt(delta_1)
# y3 = delta + 0.5*sqrt(delta_2)
# y4 = delta - 0.5*sqrt(delta_2)
#
# x = [y1 y2 y3 y4]
# return [x]
# end

# function solve_theta_roots(xp, vp, yp, wp, xe, ve, ye, we)
#     global ap ae
#
#     x = xe - xp
#     y = ye - yp
#     v = vp - ve
#     w = wp - we
#     a = ap - ae
#
#     alpha = a^2/4
#     A = (v^2 + w^2)/alpha()
#     B = (2*v*x+2*w*y)/alpha()
#     C = (x^2 + y^2)/alpha()
#
#     St = roots([1, 0, -A, B, -C])
#     min_T = inf
#     for i=1:length(St)
#         if abs(imag(St[i]))<=1e-5 && St[i]<min_T && St[i]>0
#             min_T = real(St[i])
#         end
#     end
#     T = min_T
#
# #     idx = 0
# #     max_T = 0
# #     for i=1:length(St)
# #         if abs(imag(St[i]))<=1e-5 && St[i]>max_T
# #             idx = i
# #             max_T = real(St[i])
# #         end
# #     end
# #     T = max_T
#
#     theta = atan2(y-w*T,x-v*T)
#     return [theta]
# end

