number = zeros(1000)
x = zeros(4,1)
for j=1:1000
for i =1:4 # set up simulation for 4 coin  tosses
	global number, x
	if rand() < 0.75 # toss coin with p=0.75
		x[i,1] = 1 # head
	else
		x[i,1] = 0 # tail
	end

	number[j] = number[j] + x[i,1] # count number of heads

end
end

print(number)