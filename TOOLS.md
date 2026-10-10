# Generation Tools Behind the Scene

[日本語版はこちら / Japanese](TOOLS.ja.md) · [← Artist list](README.md)

AI tools that can make songs like the ones in this list: vocal J-pop and love songs, ragga and street tracks, and Wa-rock or ritual ambient. The tools are grouped by what they do. Status is **as of 2026-10-10**. Plans, licenses and model versions change often, so check each tool's own terms before you release anything commercially. ⭐ badges show live GitHub star counts (via shields.io).

Legend: 🎤 vocals · 🎹 instrumental only · 🇯🇵 Japanese lyrics confirmed or widely used · 💻 runs locally · ☁️ cloud service

---

## 1. Commercial text-to-song (vocals + lyrics)

Most tracks in this list were probably made with one of these.

| Tool | | Status (2026-10) | Notes |
| --- | --- | --- | --- |
| [Suno](https://suno.com) | 🎤🇯🇵☁️ | **v6 / v6-wild / v6-mini** released 2026-09-09 (v6 / v6-wild paid, v6-mini for all) | The dominant tool in this scene. Licensing deal with Warner Music. Section editing, mashups and audio/image/video prompts. Credited by **Echo Scroll** and **Cyana**. |
| [Google Lyria 3.5](https://gemini.google/overview/music-generation/) | 🎤🇯🇵☁️ | Lyria 3.5 released 2026-07-29 | Available in the Gemini app, [Flow Music](https://blog.google/innovation-and-ai/models-and-research/google-labs/lyria-3-5/) and the [Gemini API](https://ai.google.dev/gemini-api/docs/music-generation). Outputs carry a SynthID watermark. **Cyana** credits Gemini. |
| [ElevenLabs Music](https://elevenlabs.io/docs/overview/capabilities/music) | 🎤☁️ | Music v2.5 released 2026-09 | Multilingual, marketed for commercial use, lossless downloads. Music Finetunes (custom-trained styles) added; v1 to be deprecated. |
| [Mureka](https://www.mureka.ai) | 🎤☁️ | V9.5 (2026-08-31) | Similar to Suno. Higher plans export stems, MIDI and DAW files. |
| [Udio](https://www.udio.com) | 🎤☁️ | Licensed "walled garden" after the UMG settlement | **Downloads disabled since 2025-10** and the licensed platform had still not launched as of late 2026-09, so it is unlikely to be a source for distributed tracks. |
| [Boomy](https://boomy.com) | 🎤☁️ | Active | Entry-level. Paid plans can distribute to streaming services. |

## 2. Instrumental / BGM generators

| Tool | | Notes |
| --- | --- | --- |
| [Stable Audio 3](https://stableaudio.com) | 🎹💻☁️ | Released 2026-05. Small and Medium are open weights. Up to about 6 minutes. |
| [AIVA](https://www.aiva.ai) | 🎹☁️ | Orchestral and cinematic. You own the copyright only on the Pro plan. |
| [SOUNDRAW](https://soundraw.io) | 🎹☁️ | From Tokyo. Royalty-free BGM with a perpetual license. |
| [Mubert](https://mubert.com) | 🎹☁️ | API and creator plans. Creator output cannot go to streaming services. |

## 3. Open-source song generation (GitHub / local)

| Model | | License | Notes |
| --- | --- | --- | --- |
| [ACE-Step 1.5](https://github.com/ace-step/ACE-Step-1.5) ![GitHub stars](https://img.shields.io/github/stars/ace-step/ACE-Step-1.5?style=flat&label=%E2%AD%90) | 🎤🇯🇵💻 | MIT | Lyrics in 50+ languages. Runs in about 6 GB of VRAM. Songs up to 10 minutes. LoRA training. Mac, AMD and CUDA. XL (4B) added 2026-04. |
| [YuE / YuE2](https://github.com/multimodal-art-projection/YuE) ![GitHub stars](https://img.shields.io/github/stars/multimodal-art-projection/YuE?style=flat&label=%E2%AD%90) | 🎤🇯🇵💻 | Apache 2.0 code (YuE); YuE2-3B weights CC BY-NC 4.0 | Supports English, Chinese, **Japanese** and Korean. Needs a lot of VRAM (24 GB or more). [YuE2-3B](https://huggingface.co/m-a-p/YuE2-3B) released 2026-09 (symbolic planning, zero-shot covers, agentic editing); its model card lists only zh/en, so Japanese support in YuE2 is unconfirmed. Many community LoRAs and GGUFs. |
| [SongGeneration / LeVo 2](https://huggingface.co/tencent/SongGeneration) | 🎤💻 | Tencent (non-commercial) | High audio quality. About 10 GB or more of VRAM. The GitHub repo (tencent-ailab/SongGeneration) returns 404 as of 2026-10-10, so this links the Hugging Face weights. |
| [HeartMuLa](https://github.com/HeartMuLa/heartlib) ![GitHub stars](https://img.shields.io/github/stars/HeartMuLa/heartlib?style=flat&label=%E2%AD%90) | 🎤💻 | Apache 2.0 | Multilingual song foundation model, 2026. |
| [DiffRhythm](https://github.com/ASLP-lab/DiffRhythm) ![GitHub stars](https://img.shields.io/github/stars/ASLP-lab/DiffRhythm?style=flat&label=%E2%AD%90) | 🎤💻 | Apache 2.0 | Fast full-song generation with diffusion. |
| [MiniMax Music 3](https://github.com/MiniMax-AI/MiniMax-Music3) ![GitHub stars](https://img.shields.io/github/stars/MiniMax-AI/MiniMax-Music3?style=flat&label=%E2%AD%90) | 🎤🇯🇵💻 | MiniMax-Music3 Community License | **New.** Open-weight lyrics-to-song model released 2026-08-13 ([weights](https://huggingface.co/MiniMaxAI/MiniMax-Music3)). Songs up to 5 minutes, 32 kHz stereo. Japanese vocals reported. Check the custom license before commercial use. |
| SongBloom | 🎤💻 | see model card | Needs a reference audio clip. The official GitHub repo (tencent-ailab/SongBloom) returns 404 as of 2026-10-10. |
| [InspireMusic](https://github.com/FunAudioLLM/InspireMusic) ![GitHub stars](https://img.shields.io/github/stars/FunAudioLLM/InspireMusic?style=flat&label=%E2%AD%90) | 🎹💻 | see repo | Instrumental only. |
| [MusicGen (AudioCraft)](https://github.com/facebookresearch/audiocraft) ![GitHub stars](https://img.shields.io/github/stars/facebookresearch/audiocraft?style=flat&label=%E2%AD%90) | 🎹💻 | MIT code / CC BY-NC weights | Classic text-to-music baseline. |

## 4. AI singers / singing voice synthesis

For "AI singer" personas such as 音奏羽アリナ, Cyana and MINORI. You can write the melody yourself and give the voice to a synth.

| Tool | | Notes |
| --- | --- | --- |
| [Synthesizer V](https://dreamtonics.com/synthesizerv/) | 🎤🇯🇵💻 | Dreamtonics. AI singing voices, strong Japanese voicebank lineup. Current version: Synthesizer V Studio 2 Pro (choir voices added). |
| [VOCALOID7 / VOCALOID6](https://www.vocaloid.com) | 🎤🇯🇵💻 | Yamaha. The original vocal synth, with AI voicebanks. **[VOCALOID7](https://www.vocaloid.com/news/news_47) announced 2026-10-09**, on sale 2026-11-11 (bundled "asa" voicebank and AI Megpoid). VOCALOID6 is at 6.13.2. |
| [ACE Studio](https://acestudio.ai) | 🎤🇯🇵💻 | AI singing with many licensed voices. Now ACE Studio 2.0. |
| [NEUTRINO](https://studio-neutrino.com) | 🎤🇯🇵💻 | Free Japanese neural singing synthesis. NEUTRINO Tau v3.2.5 (2026-10-09); a web version, Neutrino Orbit, is in alpha testing. |
| [VoiSona](https://voisona.com/) | 🎤🇯🇵💻 | **New.** Techno-Speech. Japanese AI singing synthesis, also runs as a VST3/AU plugin. The editor and the 知声 voice are free; other voices are paid. |
| [RVC](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI) ![GitHub stars](https://img.shields.io/github/stars/RVC-Project/Retrieval-based-Voice-Conversion-WebUI?style=flat&label=%E2%AD%90) | 🎤💻 | Open-source voice conversion. Only use voices you have rights to. |
| [Seed-VC](https://github.com/Plachtaa/seed-vc) ![GitHub stars](https://img.shields.io/github/stars/Plachtaa/seed-vc?style=flat&label=%E2%AD%90) | 🎤💻 | Zero-shot voice and singing conversion. The repo is now archived (read-only). |
| [SoulX-Singer](https://github.com/Soul-AILab/SoulX-Singer) ![GitHub stars](https://img.shields.io/github/stars/Soul-AILab/SoulX-Singer?style=flat&label=%E2%AD%90) | 🎤💻 | **New.** Open-source (Apache-2.0) zero-shot singing voice synthesis controlled by F0 or MIDI (2026-02), plus an SVC model. Documented languages: Mandarin, English and Cantonese. |

## 5. Post-production & release

| Tool | Role |
| --- | --- |
| [Demucs](https://github.com/adefossez/demucs) ![GitHub stars](https://img.shields.io/github/stars/adefossez/demucs?style=flat&label=%E2%AD%90) / [UVR](https://github.com/Anjok07/ultimatevocalremovergui) ![GitHub stars](https://img.shields.io/github/stars/Anjok07/ultimatevocalremovergui?style=flat&label=%E2%AD%90) | Stem separation (open source). The original facebookresearch/demucs repo is archived; the original author maintains it at adefossez/demucs. |
| [Moises](https://moises.ai) | Stems, chords, lyric transcription. Now a "creative suite" with Moises Studio. |
| [LANDR](https://www.landr.com) | AI mastering + distribution |
| [TuneCore Japan](https://www.tunecore.co.jp) | Distribution. Used by **de〜ku**, who describes themselves as an AI music creator there. |

---

## Which tools fit which cluster?

| Cluster | Likely tools |
| --- | --- |
| **A. Soft Melodic** | Suno, Lyria 3.5 / Gemini, Mureka. AI-singer projects use Synthesizer V, ACE Studio or VOCALOID. |
| **B. Hard Edge** | Suno (v6-wild for grittier textures), ElevenLabs Music. Dance and EDM beds from Stable Audio. |
| **C. Wa Spiritual** | Suno (credited by Echo Scroll), plus Stable Audio or AIVA for ambient and ritual beds. Human vocals + AI assist, as in AI AINU. |
| **Wa-rock group** | Suno with J-rock / 和楽器 prompts. ACE-Step, YuE or MiniMax Music 3 for local Japanese lyrics. |

Only a few artists state which tool they use (see "Explicit AI notes" in the README). The rest of this table is inference, not attribution.

---

*Last updated: 2026-10-10*
