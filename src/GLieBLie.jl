module GLieBLie

using Subtitles, Test
using WAV
using Dates

using PyCall, Conda
using Pkg


function __init__()
    ENV["PYTHON"] = ""
    Pkg.build("PyCall")
    Conda.add(["librosa", "numpy", "scipy", "youtube-dl", "yt-dlp"]) 

    global LIBROSA = pyimport("librosa")
    global YOUTUBE_DL = pyimport("youtube_dl")
    global YT_DLP = pyimport("yt_dlp")
end

"""

fuck it lets assume that the periods are second and millis. dates.jl so lame!!

Dates.tons being undocumented 😠
"""
function compoundperiod_to_float(cp)
  ps = Dates.value.(Dates.periods(cp))
  if length(ps) == 1
    ss = 0
    ms = ps[1]
  else
    ss, ms = ps
  end
  ss + (ms / 1000)
end

function overlay_tts(video_path, outdir)
  @assert ispath(outdir)
  @assert isfile(video_path)
  video_bn = basename(video_path)
  components_path = joinpath(outdir, "audio_components")

  mkpath(components_path)
  run(`whisper $video_path --task transcribe --output_dir $outdir`)
  full_tts_path = joinpath(outdir, "$video_path.wav")
  full_text_path = joinpath(outdir, "$video_bn.txt")
  text = read(full_text_path, String)
#   run(`tts --text $text --out_path $full_tts_path`)

  srt_path = joinpath(outdir, "$video_bn.srt")
  srt = Subtitles.parse_srt(srt_path)
  @info outdir, components_path
  realigned_fn = realign(srt, outdir, components_path)
  outfn = joinpath(outdir, "new_$(video_bn)")

  cmd = `ffmpeg -i $video_path -i $realigned_fn -c:v copy -map 0:v:0 -map 1:a:0 $outfn`
  run(cmd)
  @assert isfile(outfn)
  outfn
end

function realign(srt, outdir, components_path)
  for (i, s) in enumerate(srt)
    @info i
    # bn = string(s.start_time, "_", s.end_time, ".wav")
    t0, t1 = s.start_time, s.end_time
    bn = "$i.wav"
    fn = joinpath(components_path, bn)
    @info fn

    run(`tts --text $(s.text) --out_path $fn`)

    sig, sr = wavread(fn)
    sri = Int(sr)
    secf = size(sig, 1) / Int(sr)
    secs_t = trunc(secf)
    millis = Millisecond(round((secf % secs_t) * 1000, RoundUp))
    secs = Second(secs_t)
    duration = secs + millis
    dt = t1 - t0
    real_duration = max(dt, duration)
    # push!(durs, real_duration)

    # pad extra zeros to make duration == dt, then rewrite the wav
    # then when we concatenate all of the wavs, the duration will be roughly the same as the original video
    # we could also try to stretch it and resample, but thats lame
    sigvec = vec(sig[:, 1])
    rate = Dates.tons(duration) / Dates.tons(dt)
    sigvec = LIBROSA.effects.time_stretch(sigvec, rate=rate)
    wavwrite(sigvec, fn; Fs=sri)

    # if duration < dt
    #   del = canonicalize(dt - duration)
    #   fsecs = compoundperiod_to_float(del)
    #   zs = zeros(eltype(sig), round(Int, fsecs * sri))
    #   append!(sigvec, zs)
    #   wavwrite(sigvec, fn; Fs=sri)
    # else
    #   # i think i need to just cut it if its too long because some of the tts are way too long
    #   durt = canonicalize(dt)
    #   fsecs = compoundperiod_to_float(durt)
    #   nsamples = round(Int, fsecs * sri, RoundUp)
    #   sigvec = sigvec[1:nsamples]
    #   wavwrite(sigvec, fn; Fs=sri)
    # end

    # animate videos by stitching generated images in (todo)
    # img =  OpenAI.dalle(s)
    # push!(imgs, img)
  end

  fns = readdir(components_path; join=true)
  sort!(fns; by=x -> parse(Int, splitext(basename(x))[1]))
  wavs = wavread.(fns)

  srs = map(x -> x[2], wavs)
  sigs = vec.(first.(wavs))

  @assert allequal(srs) # 
  bigsig = vcat(sigs...)
  newdur = length(bigsig) / first(srs) # secs
  # realpath = joinpath(@__DIR__, "../data/jelly.wav")

  # jelly, jellysr = wavread(realpath)
  # realdur = size(jelly, 1) / jellysr
  realigned_fn = joinpath(outdir, "composed.wav")
  wavwrite(bigsig, realigned_fn; Fs=first(srs))
  realigned_fn
end

function doit(video_url, outdir)
    path_template = joinpath(outdir, "%(id)s.%(ext)s")
    ytdl_cmd = `yt-dlp --quiet -o $path_template $video_url`
    run(ytdl_cmd)
    # @assert !ispath(outdir)
    # mkpath(outdir)
  
    ydl = YT_DLP.YoutubeDL()
    info = ydl.extract_info(video_url, download=false)
  
    title = string(info["id"], ".", info["ext"])
    video_path = joinpath(outdir, title)
    @info video_path
    overlay_tts(video_path, outdir)
    @test isfile(video_path)
    video_path
  end

end # module GLieBLie
