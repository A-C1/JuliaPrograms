### A Pluto.jl notebook ###
# v0.19.18

using Markdown
using InteractiveUtils

# ╔═╡ 0ce3dbd0-7d3d-11ed-0b5f-6f7288fa9716
using LinearAlgebra

# ╔═╡ 095606e0-df33-4384-995b-c25dd6131629
md"
# This example demonstrates how Pivoting works.
"

# ╔═╡ c97ab07e-cfac-44eb-bee4-9db1c189ae68
Ao = [-0.5 1 0 0; 1 0 3 0; -0.5 0 -0.2 1; -0.5 -0.3 1.0 0.0]

# ╔═╡ 85744e29-6814-4fc9-be8b-5b8ae1176fc9
begin
	M1 = Matrix{Float64}(I, 4, 4)
	M2 = Matrix{Float64}(I, 4, 4)
	M3 = Matrix{Float64}(I, 4, 4)
end

# ╔═╡ fba9d131-84fd-46a6-bb96-c67eac38182f
begin
	P1 = [0 1 0 0; 1 0 0 0; 0 0 1 0; 0 0 0 1]
	A2 = P1*Ao
	
end

# ╔═╡ bc0b52b3-1e77-4b28-9d34-fd42ab074c75
begin
	M1[2:end,1] = -A2[2:end,1] / A2[1, 1]
	M1
end

# ╔═╡ cd9dcdcc-dba4-4260-869e-8d9c9280c2c7
A3 = M1*A2

# ╔═╡ 7e462cf8-812b-48f8-a2d9-3165ed4072c6
begin
	P2 = Matrix{Float64}(I, 4, 4)
	A4 = P2*A3
end

# ╔═╡ 57997f4c-0785-4af6-9b7f-61187a6fc0d5
begin
	M2[3:end, 2] = -A4[3:end, 2]/A4[2, 2]
	A5 = M2*A4
end

# ╔═╡ b037da01-d3cf-435a-b71c-7f5de58eb75d
begin
	P3 = [1 0 0 0; 0 1 0 0; 0 0 0 1; 0 0 1 0]
	A6 = P3*A5
end

# ╔═╡ cc511467-b503-4835-8953-37aa4056007d
begin
	M3[4:end, 3] = -A6[4:end, 3] / A6[3, 3]
	M3
end

# ╔═╡ 065d1420-b0d6-4c73-8bdd-e8d2e8f1a410
U = M3*A6

# ╔═╡ dc3c9b6f-07eb-44c8-ab4a-61ad893e7345
md"Thus we can write 
	
$$U = M_{3}P_{3}M_{2}P_{2}M_{1}P_{1}A$$

This can be further modified as 

$$U = M_{3}(P_{3}M_{2}P_{3}^{T})(P_{3}P_{2}M_{1}P_{2}^{T}P_{3}^{T})(P_{3}P_{2}P_{1})A$$

Finally we have:

$$U = \tilde{M}_3\tilde{M}_2\tilde{M}_1PA$$

"

# ╔═╡ f4c4125a-41be-4af3-b300-a5957048121f
P2*M1*P2'

# ╔═╡ e1f454a5-7d37-4b8e-88aa-f68baabaa262
begin
	n = 10
	A = rand(n, n)
	L = Matrix{Float64}(I, n, n)

	p = collect(1:n)  # permutation vector
	for i = 1:n         	# Selects the appropriate column
		# Find the index of the maximum element
		q = (i-1) + argmax(A[i:n,i])

		# Interchange the elements in the vector p
		p[[i, q]] = p[[q, i]] 
		
		l = A[i+1:end, i] / A[i, i]
		L[i+1:end, i] = l
		
		A[i+1:end,i:end] = A[i+1:end,i:end] - l*A[i, i:end]'
	end
end

# ╔═╡ e5765bbd-8976-4a7d-8a4f-6290f812374d
A

# ╔═╡ 4daccf8d-4686-433f-ae93-7217cd33935e
# Try implementing looping
# This works. Pluto is indeed cool for prototyping
begin
	s = 0
	for i=1:10
		s = s + 1
	end
end

# ╔═╡ f2019d63-45ed-4b2f-aea1-be063aaa9123
s

# ╔═╡ 724726c7-6e05-45e5-ad3c-5c52909aa0e5
collect(1:2)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "ac1187e548c6ab173ac57d4e72da1620216bce54"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"
"""

# ╔═╡ Cell order:
# ╟─095606e0-df33-4384-995b-c25dd6131629
# ╠═0ce3dbd0-7d3d-11ed-0b5f-6f7288fa9716
# ╠═c97ab07e-cfac-44eb-bee4-9db1c189ae68
# ╠═85744e29-6814-4fc9-be8b-5b8ae1176fc9
# ╠═fba9d131-84fd-46a6-bb96-c67eac38182f
# ╠═bc0b52b3-1e77-4b28-9d34-fd42ab074c75
# ╠═cd9dcdcc-dba4-4260-869e-8d9c9280c2c7
# ╠═7e462cf8-812b-48f8-a2d9-3165ed4072c6
# ╠═57997f4c-0785-4af6-9b7f-61187a6fc0d5
# ╠═b037da01-d3cf-435a-b71c-7f5de58eb75d
# ╠═cc511467-b503-4835-8953-37aa4056007d
# ╠═065d1420-b0d6-4c73-8bdd-e8d2e8f1a410
# ╟─dc3c9b6f-07eb-44c8-ab4a-61ad893e7345
# ╠═f4c4125a-41be-4af3-b300-a5957048121f
# ╠═e1f454a5-7d37-4b8e-88aa-f68baabaa262
# ╠═e5765bbd-8976-4a7d-8a4f-6290f812374d
# ╠═4daccf8d-4686-433f-ae93-7217cd33935e
# ╠═f2019d63-45ed-4b2f-aea1-be063aaa9123
# ╠═724726c7-6e05-45e5-ad3c-5c52909aa0e5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
