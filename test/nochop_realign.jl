# function realign_nochop(text, outdir, components_path)

    run(`tts --text $(s.text) --out_path $fn`)

# end


# outdir = joinpath(DATADIR, "video3")
video_path = "data/docs.mp4"

overlay_tts(video_path, outdir)


# mkpath(components_path)
# run(`whisper $video_path --task transcribe --output_dir $outdir`)
# full_tts_path = joinpath(outdir, "$video_path.wav")
# text = read(full_tts_path, String)
run(`tts --text $text --out_path $full_tts_path`)
video_bn = basename(video_path)
srt = Subtitles.parse_srt(joinpath(outdir, "$video_bn.srt"))
realign(srt, outdir, components_path)
