using Plots

num_trials =  2000
rel_freq_tmp = 0
rel_freq = zeros(num_trials)


for i = 1:num_trials
    global rel_freq_tmp
	x = rand()
    if x < 0.4
        rel_freq_tmp += 1
    end
    rel_freq[i] = rel_freq_tmp/i
end

fig1 = plot(rel_freq)
display(fig1)
