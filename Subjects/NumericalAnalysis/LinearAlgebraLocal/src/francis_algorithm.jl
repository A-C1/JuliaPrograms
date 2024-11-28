function francis(A)
	A = deepcopy(A)
    for i = 1:20
        global A
        Q, R = qr(A)
        A = R * Q
    end
	return A
end
