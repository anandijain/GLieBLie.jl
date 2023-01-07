# GLieBLie

using openai/whisper and mozilla/tts to fine tune a tts model on [runforthecube](https://www.youtube.com/@runforthecube)'s channel

[glieblie](https://www.youtube.com/watch?v=V0xzLlTEFSQ)
[docs](https://youtu.be/L8RDvcPyIaI)
```julia
using GLieBLie
# this one takes like 10 minutes 
outdir = joinpath(@__DIR__, "data/glieblie")
mkpath(outdir)
video_url = "https://www.youtube.com/watch?v=T4r91mc8pbo"
GLieBLie.doit(video_url, outdir)


# real test video (faster, ytdl is kinda slow ( i BLAME YOU YOUTUBE))
# this one takes just a minute or so
outdir = joinpath(@__DIR__, "data/test_video")
mkpath(outdir)
video_url = "https://www.youtube.com/watch?v=BaW_jenozKc"
GLieBLie.doit(video_url, outdir)
```

we have the overlaying of tts on an existing video working.

next steps use yark or normal youtube-dl to download the entire runforthecube archive and fine tune mozilla/tts on it 

## todo 
1. make it faster by switching tts and whsiper calls from `run(::Cmd)`s to PyCalls
2. download runforthecube archive and fine tune mozilla/tts on it
2. , cleanup redirect stdout and add a progress bar on audio segment generation
1. try tts/  --reference_wav argument and multispeaker
    * it would be interesting to try to fine tune multispeaker, ie, we know what runforthecube sounds like and could identify it given a random piece of audio.
3. make options for choices of how to recompose the audio 
    - also allow `tts`ing the entire transcript at once and perform a single timestretch, instead of chopping up the srt and stretching each line. 

known issues:
tts/ doesn't seem to build on M1, because their dependencies are super bloated 


yark new runforthecube https://www.youtube.com/@runforthecube