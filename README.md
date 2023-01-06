# GLieBLie

using openai/whisper and mozilla/tts to fine tune a tts model on [runforthecube](https://www.youtube.com/@runforthecube)'s channel

[demo](https://www.youtube.com/watch?v=V0xzLlTEFSQ)
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

todo try tts/
 --reference_wav 
it would be interesting to try to fine tune multispeaker, ie, we know what runforthecube sounds like and could identify it
given a random piece of audio.


try just `tts`ing the entire transcript at once and perform a single timestretch, instead of chopping up the srt and stretching each line. 
    * make options for choices of how to recompose the audio 

also need to call tts from python to avoid needing to remake the synthesizer and load the model into RAM every time. I'm pretty sure this will make tts part much faster

known issues:
tts/ doesn't seem to build on M1, because their dependencies are super bloated 