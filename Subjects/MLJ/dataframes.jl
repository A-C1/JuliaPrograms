using DataFrames
using CSV
using GLMakie

read_csv = false

if read_csv == true
    puzzles = CSV.read("puzzles.csv", DataFrame; select = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], delim = ",");
    puzzles = puzzles[!, 1:9]
end

using Statistics
plays_lo = median(puzzles.NbPlays)
hist(puzzles.NbPlays, bins = 500, normalization = :density)


