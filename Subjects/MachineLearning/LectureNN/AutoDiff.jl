import Base:+,* 

mutable struct Variable
	value::Float64                     # Stores the value of the variable
	derivative::Float64                # Stores the value of derivative
	parents::Vector{Variable}          # Stores the input variables
	local_derivatives::Vector{Float64} # Local derivatives of outputs with respect to input variables

	function Variable(value)
		x = new()					    
		x.value = value
		x.derivative = 0.0
		x.parents = []
		x.local_derivatives = []
		return x
	end
end

function +(a::Variable, b::Variable)
	value = a.value + b.value
	C = Variable(value) 
	C.parents = [a, b]
	C.local_derivatives = [1.0, 1.0]
	return C
end

function *(a::Variable, b::Variable)
	value = a.value*b.value
	C = Variable(value)
	C.parents = [a, b]
	C.local_derivatives = [b.value, a.value]
	return C
end

# Set all the gradients to zero initially
function set_derivatives_to_zero(C::Variable)
	for i = 1:length(C.parents)
		C.parents[i].derivative = 0.0
	    set_derivatives_to_zero(C.parents[i])
	end
	return nothing
end

# Backpropogation of derivatives
function recursive_derivative(C::Variable)
	for i = 1:length(C.parents)
		C.parents[i].derivative += C.derivative * C.local_derivatives[i] 
		recursive_derivative(C.parents[i])
	end
	return nothing
end

function calc_derivative(C::Variable)
	C.derivative = 1.0
	set_derivatives_to_zero(C)
	recursive_derivative(C)
end


x = Variable(3.0)
y = Variable(4.0)
z = (x*x*x + x*x)*(y*y)

calc_derivative(z)
println("Derivative of z w.r.t x:", x.derivative)
println("Derivative of z w.r.t x:", y.derivative)







