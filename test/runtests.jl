using GLieBLie
using Subtitles, Test
using OpenAI
using WAV
using Dates

using PyCall, Conda
ENV["PYTHON"] = ""
Pkg.build("PyCall")
Conda.add(["librosa", "numpy", "scipy", "youtube-dl"])
LIBROSA = pyimport("librosa")
YOUTUBE_DL = pyimport("youtube_dl")

outdir = joinpath(GLieBLie.DATADIR, "video")
video_url = "https://www.youtube.com/watch?v=BaW_jenozKc"
GLieBLie.doit(video_url, outdir)


# video_path = joinpath(@__DIR__, "../data/harry.mp4")

# durs = []
# imgs = []
# overlay_tts(video_path, outdir)

# video_path = "data/docs.mp4"
# outdir = joinpath(DATADIR, "video3")

# overlay_tts(video_path, outdir)


# # mkpath(components_path)
# # run(`whisper $video_path --task transcribe --output_dir $outdir`)
# # full_tts_path = joinpath(outdir, "$video_path.wav")
# # text = read(full_tts_path, String)
# run(`tts --text $text --out_path $full_tts_path`)
# video_bn = basename(video_path)
# srt = Subtitles.parse_srt(joinpath(outdir, "$video_bn.srt"))
# realign(srt, outdir, components_path)



# wav_duration(sig, sr) = size(sig, 1) / sr
# wav_duration(wavread("/workspaces/codespaces-blank/tts/GLieBLie/test/data/video3/composed.wav")[1:2]...)


# # youtube-dl --format "bestvideo[height<=500][width<=800]" https://www.youtube.com/watch?v=tAmIL93WagA

# "https://www.youtube.com/watch?v=u3k6B5j1sVI"


# outdir = joinpath(DATADIR, "video4")
# "assume outdir exists already"


# # video_path = py"""
# # def get_title(url):
# #   ydl = youtube_dl.YoutubeDL()
# #   video_title = info['title']
# #   video_ext = info['ext']
# #   video_path = '/home/Tom/Videos/{}.{}'.format(video_title, video_ext)
# # """
# print(video_path)

# print(video_path)
