using GLieBLie
using PyCall, Conda
using Serialization
using CSV, DataFrames

Conda.add("yt-dlp")
yt_dlp = pyimport("yt_dlp")
ydl= yt_dlp.YoutubeDL()
# info = ydl.extract_info("https://www.youtube.com/@sippy_cups", download=false)
info = ydl.extract_info("https://www.youtube.com/@runforthecube", download=false)
es = info["entries"]
E = es[1]
vids = E["entries"]

alks = collect.(keys.(vids))
cols  = union(alks...)
for i in 1:length(vids)
    missing_cols = setdiff(cols, keys(vids[i]))
    for c in missing_cols
        vids[i][c] = missing
    end
end

df = DataFrame(cols .=> (Any[],))
for v in vids
    push!(df, v)
end
df = DataFrame(vids)
DataFrame(cols .=> (Any[],))



dfr_ = df[:, [:id, :title, :view_count, :duration]]



https://www.youtube.com/watch?v=T4r91mc8pbo https://www.youtube.com/watch?v=kufMT00dEbI https://www.youtube.com/watch?v=Ob-04pTPtSQ https://www.youtube.com/watch?v=9chX0zUO5Uk https://www.youtube.com/watch?v=LVbh4l6Me4M
base = "https://www.youtube.com/watch?v="

dfr = filter!(x->x.view_count > 100_000, dfr_)
CSV.write("archive.csv", dfr)
dfr = CSV.read(joinpath(@__DIR__, "../data/rftc/archive.csv"))
urls = base .* dfr[:, :id]


for id in dfr.id
    ydl.download_with_info_file(id)
    # run(`yt-dlp $url`)
end