# Generation Tools Behind the Scene

[日本語版はこちら / Japanese](TOOLS.ja.md) · [← Artist list](README.md)

AI tools that can make songs like the ones in this list: vocal J-pop and love songs, ragga and street tracks, and Wa-rock or ritual ambient. The tools are grouped by what they do. Status is **as of 2026-09-26**. Plans, licenses and model versions change often, so check each tool's own terms before you release anything commercially.

Legend: 🎤 vocals · 🎹 instrumental only · 🇯🇵 Japanese lyrics confirmed or widely used · 💻 runs locally · ☁️ cloud service

---

## 1. Commercial text-to-song (vocals + lyrics)

Most tracks in this list were probably made with one of these.

| Tool | | Status (2026-09) | Notes |
| --- | --- | --- | --- |
| [Suno](https://suno.com) | 🎤🇯🇵☁️ | **v6 / v6-wild / v6-mini** released 2026-09-09 | The dominant tool in this scene. Licensing deal with Warner Music. Section editing, mashups and audio/image/video prompts. Credited by **Echo Scroll** and **Cyana**. |
| [Google Lyria 3.5](https://gemini.google/overview/music-generation/) | 🎤🇯🇵☁️ | Lyria 3.5 released 2026-07-29 | Available in the Gemini app, [Flow Music](https://blog.google/innovation-and-ai/models-and-research/google-labs/lyria-3-5/) and the [Gemini API](https://ai.google.dev/gemini-api/docs/music-generation). Outputs carry a SynthID watermark. **Cyana** credits Gemini. |
| [ElevenLabs Music](https://elevenlabs.io/docs/overview/capabilities/music) | 🎤☁️ | Music v2.5 released 2026-09 | Multilingual, marketed for commercial use, lossless downloads. |
| [Mureka](https://www.mureka.ai) | 🎤☁️ | V9.5 | Similar to Suno. Higher plans export stems, MIDI and DAW files. |
| [Udio](https://www.udio.com) | 🎤☁️ | Licensed "walled garden" after the UMG settlement | **Downloads disabled since 2025-10**, so it is unlikely to be a source for distributed tracks. |
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
| [ACE-Step 1.5](https://github.com/ace-step/ACE-Step-1.5) | 🎤🇯🇵💻 | MIT | Lyrics in 50+ languages. Runs in about 6 GB of VRAM. Songs up to 10 minutes. LoRA training. Mac, AMD and CUDA. XL (4B) added 2026-04. |
| [YuE / YuE2](https://github.com/multimodal-art-projection/YuE) | 🎤🇯🇵💻 | Apache 2.0 (YuE) | Supports English, Chinese, **Japanese** and Korean. Needs a lot of VRAM (24 GB or more). YuE2 weights may use a different license, so check its model card. |
| [SongGeneration / LeVo 2](https://github.com/tencent-ailab/SongGeneration) | 🎤💻 | Tencent (non-commercial) | High audio quality. About 10 GB or more of VRAM. |
| [HeartMuLa](https://github.com/HeartMuLa/heartlib) | 🎤💻 | Apache 2.0 | Multilingual song foundation model, 2026. |
| [DiffRhythm](https://github.com/ASLP-lab/DiffRhythm) | 🎤💻 | Apache 2.0 | Fast full-song generation with diffusion. |
| [SongBloom](https://github.com/tencent-ailab/SongBloom) | 🎤💻 | see repo | Needs a reference audio clip. |
| [InspireMusic](https://github.com/FunAudioLLM/InspireMusic) | 🎹💻 | see repo | Instrumental only. |
| [MusicGen (AudioCraft)](https://github.com/facebookresearch/audiocraft) | 🎹💻 | MIT code / CC BY-NC weights | Classic text-to-music baseline. |

## 4. AI singers / singing voice synthesis

For "AI singer" personas such as 音奏羽アリナ, Cyana and MINORI. You can write the melody yourself and give the voice to a synth.

| Tool | | Notes |
| --- | --- | --- |
| [Synthesizer V](https://dreamtonics.com/synthesizerv/) | 🎤🇯🇵💻 | Dreamtonics. AI singing voices, strong Japanese voicebank lineup. |
| [VOCALOID6](https://www.vocaloid.com) | 🎤🇯🇵💻 | Yamaha. The original vocal synth, with AI voicebanks. |
| [ACE Studio](https://acestudio.ai) | 🎤🇯🇵💻 | AI singing with many licensed voices. |
| [NEUTRINO](https://studio-neutrino.com) | 🎤🇯🇵💻 | Free Japanese neural singing synthesis. |
| [RVC](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI) | 🎤💻 | Open-source voice conversion. Only use voices you have rights to. |
| [Seed-VC](https://github.com/Plachtaa/seed-vc) | 🎤💻 | Zero-shot voice and singing conversion. |

## 5. Post-production & release

| Tool | Role |
| --- | --- |
| [Demucs](https://github.com/facebookresearch/demucs) / [UVR](https://github.com/Anjok07/ultimatevocalremovergui) | Stem separation (open source) |
| [Moises](https://moises.ai) | Stems, chords, lyric transcription |
| [LANDR](https://www.landr.com) | AI mastering + distribution |
| [TuneCore Japan](https://www.tunecore.co.jp) | Distribution. Used by **de〜ku**, who describes themselves as an AI music creator there. |

---

## Which tools fit which cluster?

| Cluster | Likely tools |
| --- | --- |
| **A. Soft Melodic** | Suno, Lyria 3.5 / Gemini, Mureka. AI-singer projects use Synthesizer V or ACE Studio. |
| **B. Hard Edge** | Suno (v6-wild for grittier textures), ElevenLabs Music. Dance and EDM beds from Stable Audio. |
| **C. Wa Spiritual** | Suno (credited by Echo Scroll), plus Stable Audio or AIVA for ambient and ritual beds. Human vocals + AI assist, as in AI AINU. |
| **Wa-rock group** | Suno with J-rock / 和楽器 prompts. ACE-Step or YuE for local Japanese lyrics. |

Only a few artists state which tool they use (see "Explicit AI notes" in the README). The rest of this table is inference, not attribution.

---

*Last updated: 2026-09-26*
