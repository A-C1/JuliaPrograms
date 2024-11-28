using Random, Plots

A = collect(0.1:0.1:5)
Pe = zeros(length(A))

for k=1:length(A)
	error = 0
	for i=1:1000
		w=randn()
		if (A[k]/2+w)<=0
			error = error + 1
		end
	end
	Pe[k] = error/1000
end

plot(A,Pe)