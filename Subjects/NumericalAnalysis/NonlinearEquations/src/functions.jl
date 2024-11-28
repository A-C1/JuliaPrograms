
"function [p,n] = bisect(func,a,b,fa,fb,atol)

Assuming fa = func(a), fb = func(b), and fa*fb < 0,
there is a value root in (a,b) such that func(root) = 0.
This function returns in p a value such that
| p - root | < atol
and in n the number of iterations required."
function bisect(func, a, b, atol)
    fa = func(a)
    fb = func(b)

    # Check input
    if (a >= b) || (fa * fb >= 0) || (atol <= 0)
        println("something wrong with the input: quitting")
        p = NaN
        n = NaN
        return p, n
    end

    n = Int(ceil(log2(b - a) - log2(2 * atol)))
    for k = 1:n
        p = (a + b) / 2
        fp = func(p)
        if fa * fp < 0
            b = p
            fb = fp
        else
            a = p
            fa = fp
        end
    end

    p = (a + b) / 2

    return p, n
end


"Implements fixed point algorithm"
function fixed_point_iteration(f, x0, tol)
	max_iter = 1000
	x = x0
	counter = 0
	for i=1:max_iter
		counter += 1
		x = f(x0)
		if abs(x0-x) < tol*(1 + abs(x))
			break
		end
		x0 = x
	end	
	return x, counter
end

"Implements Newtons Method"
function newtons_method(f, fd, x0, tol)
	max_iter = 1000
	x = x0
	counter = 0
	for i=1:max_iter
		counter += 1
		x = x0 - f(x0)/fd(x0)
		if abs(x0-x) < tol*(1 + abs(x))
			break
		end
		x0 = x
	end	
	return x, counter
end

"Implements Secant Method"
function secant_method(f, fd, x0, x1, tol)
	max_iter = 1000
	x = x0
	counter = 0
	for i=1:max_iter
		counter += 1
		x = x0 - f(x0)*(x0-x1)/(f(x0)-f(x1))
		if abs(x0-x) < tol*(1 + abs(x))
			break
		end
		x0 = x
	end	
	return x, counter
end