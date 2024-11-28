import Downloads

if isfile("new_puzzles.csv.bz2")
    @info "File already present"
else
    @info "fetching file"
    Downloads.download("https://database.lichess.org/" *
                       "lichess_db_puzzle.csv.bz2",
                       "new_puzzles.csv.bz2")
end

using CodecBzip2

filename = "puzzles.csv"
if isfile(filename)
    @info "CSV file is already present!!"
else
    @info "Converting to CSV file"
    compressed = read("new_puzzles.csv.bz2")
    plain = transcode(Bzip2Decompressor, compressed)

    header = "PuzzleId,FEN,Moves,Rating,RatingDeviation,Popularity,NbPlays,Themes,GameUrl,OpeningTags"
    io = open(filename, "w")
    println(io, header)   
    write(io, plain)
end
