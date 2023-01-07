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



dfr_ = df[:, [:id, :title, :view_count, :duration]]
dfr = filter!(x->x.view_count > 100_000, dfr_)

CSV.write("archive.csv", dfr)

dfr = CSV.read(joinpath(@__DIR__, "../data/rftc/archive.csv"), DataFrame)
base = "https://www.youtube.com/watch?v="
urls = base .* dfr[:, :id]

# path_template = joinpath(outdir, "%(id)s.%(ext)s")
datadir = joinpath(@__DIR__, "../data/")
outdir = joinpath(@__DIR__, "../data/rftc/")
batch_file = joinpath(datadir, "batch_file.txt")
# ytdlp args
# -N 8
# -a batch_file
# - 
# @__DIR__
run(`yt-dlp -s -q --progress -N 8 -a $batch_file `)
videos = readdir(outdir; join=true)

for video in videos
    # mv(video, video_path;force=true)
    video_name, ext = splitext(basename(video))
    video_dir = joinpath(outdir, video_name)
    video_path = joinpath(video_dir, "$video_name$ext")
    mkpath(video_dir)
    run(`whisper $video --verbose False --threads 8 --output_dir $video_dir`)
end


models = "tiny.en","tiny","base.en","base","small.en","small"
video = first(videos)
ts = []
for m in models 
    cmd = `whisper --model $m $video --verbose False --threads 8 --output_dir $video_dir`
    t = @elapsed(read(cmd, String))
    push!(ts, t)
end

run(`yt-dlp --write-auto-sub --convert-subs=srt --skip-download -a $batch_file`)


# 461.445541524 seconds 
# 175.623620604 "tiny.en"
# 10676/24978 [02:57<06:25, 37.09frames/s]

# Path: test/whisper.jl

