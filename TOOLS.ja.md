# このシーンを支える生成ツール

[English](TOOLS.md) · [← アーティスト一覧](README.ja.md)

このリストにあるような曲を作れる AI ツールを、用途別にまとめています。対象はボーカル入りの J-POP や恋愛曲、ラガ／ストリート、和ロック、儀式アンビエントなどです。情報は **2026-10-10 時点** のものです。プランやライセンス、モデルのバージョンはよく変わるので、商用で配信する前には必ず各ツールの規約を確認してください。⭐ バッジは GitHub のスター数をリアルタイム表示します(shields.io)。

凡例: 🎤 ボーカル対応 · 🎹 インストのみ · 🇯🇵 日本語歌詞の対応を確認済み、または日本語での利用が多い · 💻 ローカル実行 · ☁️ クラウド

---

## 1. 商用 テキスト→楽曲生成(ボーカル・歌詞あり)

このリストの曲の多くは、おそらくこのどれかで作られています。

| ツール | | 状況(2026-10) | メモ |
| --- | --- | --- | --- |
| [Suno](https://suno.com) | 🎤🇯🇵☁️ | **v6 / v6-wild / v6-mini** を 2026-09-09 に公開(v6 / v6-wild は有料、v6-mini は全員利用可) | このシーンで一番使われているツール。Warner Music とライセンス契約。部分編集、マッシュアップ、音声・画像・動画からの生成に対応。**Echo Scroll**・**Cyana** がクレジットに記載。 |
| [Google Lyria 3.5](https://gemini.google/overview/music-generation/) | 🎤🇯🇵☁️ | Lyria 3.5 を 2026-07-29 に公開 | Gemini アプリ、[Flow Music](https://blog.google/innovation-and-ai/models-and-research/google-labs/lyria-3-5/)、[Gemini API](https://ai.google.dev/gemini-api/docs/music-generation) で使える。出力には SynthID の透かしが入る。**Cyana** が Gemini をクレジットに記載。 |
| [ElevenLabs Music](https://elevenlabs.io/docs/overview/capabilities/music) | 🎤☁️ | Music v2.5 を 2026-09 に公開 | 多言語対応。商用利用を前提にしている。ロスレスでダウンロード可能。Music Finetunes(独自スタイルの学習)を追加。v1 は廃止予定。 |
| [Mureka](https://www.mureka.ai) | 🎤☁️ | V9.5(2026-08-31) | Suno と似たツール。上位プランではステム・MIDI・DAW 形式で書き出せる。 |
| [Udio](https://www.udio.com) | 🎤☁️ | UMG と和解した後、ライセンス済みの「囲い込み型」サービスに移行 | **2025-10 からダウンロード不可**。2026-09 下旬時点でもライセンス済みプラットフォームは未公開。配信されている曲の制作元である可能性は低い。 |
| [Boomy](https://boomy.com) | 🎤☁️ | 稼働中 | 初心者向け。有料プランならストリーミング配信できる。 |

## 2. インスト／BGM 生成

| ツール | | メモ |
| --- | --- | --- |
| [Stable Audio 3](https://stableaudio.com) | 🎹💻☁️ | 2026-05 公開。Small と Medium はモデルの重みも公開。最長およそ6分。 |
| [AIVA](https://www.aiva.ai) | 🎹☁️ | オーケストラ・映画音楽向け。著作権を自分のものにできるのは Pro プランのみ。 |
| [SOUNDRAW](https://soundraw.io) | 🎹☁️ | 東京発。ロイヤリティフリーの BGM で、ライセンスは無期限。 |
| [Mubert](https://mubert.com) | 🎹☁️ | API とクリエイター向けプラン。クリエイタープランの曲はストリーミング配信できない。 |

## 3. オープンソース楽曲生成(GitHub／ローカル)

| モデル | | ライセンス | メモ |
| --- | --- | --- | --- |
| [ACE-Step 1.5](https://github.com/ace-step/ACE-Step-1.5) ![GitHub stars](https://img.shields.io/github/stars/ace-step/ACE-Step-1.5?style=flat&label=%E2%AD%90) | 🎤🇯🇵💻 | MIT | 歌詞は50以上の言語に対応。VRAM 6GB 程度から動く。最長10分。LoRA 学習に対応。Mac・AMD・CUDA で動作。2026-04 に XL(4B)を追加。 |
| [YuE / YuE2](https://github.com/multimodal-art-projection/YuE) ![GitHub stars](https://img.shields.io/github/stars/multimodal-art-projection/YuE?style=flat&label=%E2%AD%90) | 🎤🇯🇵💻 | コードは Apache 2.0(YuE)、YuE2-3B の重みは CC BY-NC 4.0 | 英語・中国語・**日本語**・韓国語に対応。VRAM を多く使う(24GB 以上)。2026-09 に [YuE2-3B](https://huggingface.co/m-a-p/YuE2-3B) を公開(記号的プランニング、ゼロショットカバー、エージェント的編集)。モデルカードの対応言語は中国語・英語のみで、YuE2 の日本語対応は未確認。コミュニティ製の LoRA や GGUF が多い。 |
| [SongGeneration / LeVo 2](https://huggingface.co/tencent/SongGeneration) | 🎤💻 | Tencent 独自(非商用のみ) | 音質が高い。VRAM 10GB 以上が目安。GitHub リポジトリ(tencent-ailab/SongGeneration)は 2026-10-10 時点で 404 のため、Hugging Face の重みにリンク。 |
| [HeartMuLa](https://github.com/HeartMuLa/heartlib) ![GitHub stars](https://img.shields.io/github/stars/HeartMuLa/heartlib?style=flat&label=%E2%AD%90) | 🎤💻 | Apache 2.0 | 2026年の多言語対応の楽曲生成モデル。 |
| [DiffRhythm](https://github.com/ASLP-lab/DiffRhythm) ![GitHub stars](https://img.shields.io/github/stars/ASLP-lab/DiffRhythm?style=flat&label=%E2%AD%90) | 🎤💻 | Apache 2.0 | 拡散モデルで1曲を丸ごと高速に生成する。 |
| [MiniMax Music 3](https://github.com/MiniMax-AI/MiniMax-Music3) ![GitHub stars](https://img.shields.io/github/stars/MiniMax-AI/MiniMax-Music3?style=flat&label=%E2%AD%90) | 🎤🇯🇵💻 | MiniMax-Music3 Community License | **新規。** 2026-08-13 公開のオープンウェイト歌詞→楽曲生成モデル([重み](https://huggingface.co/MiniMaxAI/MiniMax-Music3))。最長5分、32kHz ステレオ。日本語ボーカルの生成が報告されている。商用利用の前に独自ライセンスを確認すること。 |
| SongBloom | 🎤💻 | モデルカード参照 | 参照用の音声が必要。公式 GitHub リポジトリ(tencent-ailab/SongBloom)は 2026-10-10 時点で 404。 |
| [InspireMusic](https://github.com/FunAudioLLM/InspireMusic) ![GitHub stars](https://img.shields.io/github/stars/FunAudioLLM/InspireMusic?style=flat&label=%E2%AD%90) | 🎹💻 | リポジトリ参照 | インストのみ。 |
| [MusicGen (AudioCraft)](https://github.com/facebookresearch/audiocraft) ![GitHub stars](https://img.shields.io/github/stars/facebookresearch/audiocraft?style=flat&label=%E2%AD%90) | 🎹💻 | コードは MIT、重みは CC BY-NC | テキスト→音楽生成の定番ベースライン。 |

## 4. AIシンガー／歌声合成

音奏羽アリナ、Cyana、MINORI のような「AIシンガー」を作るためのツールです。メロディは自分で作り、歌声だけを合成させる使い方もできます。

| ツール | | メモ |
| --- | --- | --- |
| [Synthesizer V](https://dreamtonics.com/synthesizerv/) | 🎤🇯🇵💻 | Dreamtonics 製。AI 歌声合成で、日本語ボイスが充実している。現行は Synthesizer V Studio 2 Pro(コーラス用ボイスを追加)。 |
| [VOCALOID7 / VOCALOID6](https://www.vocaloid.com) | 🎤🇯🇵💻 | ヤマハ製。歌声合成の元祖で、AI ボイスバンクもある。**2026-10-09 に [VOCALOID7](https://www.vocaloid.com/news/news_47) を発表**、2026-11-11 発売(ボイスバンク「asa」と AI Megpoid を同梱)。VOCALOID6 は 6.13.2。 |
| [ACE Studio](https://acestudio.ai) | 🎤🇯🇵💻 | 権利処理済みのボイスが多い AI 歌声合成。現在は ACE Studio 2.0。 |
| [NEUTRINO](https://studio-neutrino.com) | 🎤🇯🇵💻 | 無料で使える日本語の AI 歌声合成。NEUTRINO Tau v3.2.5(2026-10-09)。Web 版「Neutrino Orbit」をα版でテスト中。 |
| [VoiSona](https://voisona.com/) | 🎤🇯🇵💻 | **新規。** テクノスピーチ製の日本語 AI 歌声合成。VST3/AU プラグインとしても動く。エディタと「知声」ボイスは無料、他のボイスは有料。 |
| [RVC](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI) ![GitHub stars](https://img.shields.io/github/stars/RVC-Project/Retrieval-based-Voice-Conversion-WebUI?style=flat&label=%E2%AD%90) | 🎤💻 | オープンソースの声質変換。自分に権利がある声にだけ使うこと。 |
| [Seed-VC](https://github.com/Plachtaa/seed-vc) ![GitHub stars](https://img.shields.io/github/stars/Plachtaa/seed-vc?style=flat&label=%E2%AD%90) | 🎤💻 | 事前学習なしで話し声・歌声を変換できる。リポジトリはアーカイブ済み(読み取り専用)。 |
| [SoulX-Singer](https://github.com/Soul-AILab/SoulX-Singer) ![GitHub stars](https://img.shields.io/github/stars/Soul-AILab/SoulX-Singer?style=flat&label=%E2%AD%90) | 🎤💻 | **新規。** F0 や MIDI で制御するオープンソース(Apache-2.0)のゼロショット歌声合成(2026-02)。歌声変換(SVC)モデルもある。対応言語は中国語・英語・広東語(日本語は未記載)。 |

## 5. 仕上げ・配信

| ツール | 役割 |
| --- | --- |
| [Demucs](https://github.com/adefossez/demucs) ![GitHub stars](https://img.shields.io/github/stars/adefossez/demucs?style=flat&label=%E2%AD%90) / [UVR](https://github.com/Anjok07/ultimatevocalremovergui) ![GitHub stars](https://img.shields.io/github/stars/Anjok07/ultimatevocalremovergui?style=flat&label=%E2%AD%90) | パートごとの分離(オープンソース)。元の facebookresearch/demucs はアーカイブ済みで、作者本人が adefossez/demucs で保守している。 |
| [Moises](https://moises.ai) | パート分離、コード検出、歌詞の書き起こし。Moises Studio を加えた「クリエイティブスイート」に拡大。 |
| [LANDR](https://www.landr.com) | AI マスタリング＋配信 |
| [TuneCore Japan](https://www.tunecore.co.jp) | 配信代行。**de〜ku** がここで「AIミュージッククリエイター」と名乗っている。 |

---

## クラスタ別に合いそうなツール

| クラスタ | 合いそうなツール |
| --- | --- |
| **A. Soft Melodic** | Suno、Lyria 3.5 / Gemini、Mureka。AIシンガー系のプロジェクトは Synthesizer V、ACE Studio、VOCALOID。 |
| **B. Hard Edge** | Suno(荒い質感が欲しいなら v6-wild)、ElevenLabs Music。ダンス・EDM 系の下地は Stable Audio。 |
| **C. Wa Spiritual** | Suno(Echo Scroll がクレジットに記載)。アンビエントや儀式系の下地は Stable Audio や AIVA。AI AINU のように、歌は人間で AI は補助という作り方もある。 |
| **和ロック群** | Suno で J-Rock・和楽器系のプロンプトを使う。日本語歌詞をローカルで作るなら ACE-Step、YuE、MiniMax Music 3。 |

使っているツールを本人が明かしているアーティストは少数です(README の「AIに関する明示メモ」を参照)。それ以外のこの表の内容は推測で、そのツールで作られたと断定するものではありません。

---

*最終更新: 2026-10-10*
