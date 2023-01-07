using GLieBLie
using Subtitles, Test
using WAV
using Dates
using Pkg

outdir = joinpath(@__DIR__, "../data/video")
@test !ispath(outdir)
video_url = "https://www.youtube.com/watch?v=BaW_jenozKc"
GLieBLie.doit(video_url, outdir)
@test !isempty(readdir(outdir))
