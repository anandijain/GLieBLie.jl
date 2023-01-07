using GLieBLie
using Subtitles, Test
using WAV
using Dates

using PyCall, Conda
ENV["PYTHON"] = ""
Pkg.build("PyCall")
Conda.add(["librosa", "numpy", "scipy", "youtube-dl"])
LIBROSA = pyimport("librosa")
YOUTUBE_DL = pyimport("youtube_dl")

outdir = joinpath(@__DIR__, "../data/video")
@test !ispath(outdir)
video_url = "https://www.youtube.com/watch?v=BaW_jenozKc"
GLieBLie.doit(video_url, outdir)
@test !isempty(readdir(outdir))