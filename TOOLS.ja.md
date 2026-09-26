# このシーンを支える生成ツール

[English](TOOLS.md) · [← アーティスト一覧](README.ja.md)

このリストにあるような曲を作れる AI ツールを、用途別にまとめています。対象はボーカル入りの J-POP や恋愛曲、ラガ／ストリート、和ロック、儀式アンビエントなどです。情報は **2026-09-26 時点** のものです。プランやライセンス、モデルのバージョンはよく変わるので、商用で配信する前には必ず各ツールの規約を確認してください。

凡例: 🎤 ボーカル対応 · 🎹 インストのみ · 🇯🇵 日本語歌詞の対応を確認済み、または日本語での利用が多い · 💻 ローカル実行 · ☁️ クラウド

---

## 1. 商用 テキスト→楽曲生成(ボーカル・歌詞あり)

このリストの曲の多くは、おそらくこのどれかで作られています。

| ツール | | 状況(2026-09) | メモ |
| --- | --- | --- | --- |
| [Suno](https://suno.com) | 🎤🇯🇵☁️ | **v6 / v6-wild / v6-mini** を 2026-09-09 に公開 | このシーンで一番使われているツール。Warner Music とライセンス契約。部分編集、マッシュアップ、音声・画像・動画からの生成に対応。**Echo Scroll**・**Cyana** がクレジットに記載。 |
| [Google Lyria 3.5](https://gemini.google/overview/music-generation/) | 🎤🇯🇵☁️ | Lyria 3.5 を 2026-07-29 に公開 | Gemini アプリ、[Flow Music](https://blog.google/innovation-and-ai/models-and-research/google-labs/lyria-3-5/)、[Gemini API](https://ai.google.dev/gemini-api/docs/music-generation) で使える。出力には SynthID の透かしが入る。**Cyana** が Gemini をクレジットに記載。 |
| [ElevenLabs Music](https://elevenlabs.io/docs/overview/capabilities/music) | 🎤☁️ | Music v2.5 を 2026-09 に公開 | 多言語対応。商用利用を前提にしている。ロスレスでダウンロード可能。 |
| [Mureka](https://www.mureka.ai) | 🎤☁️ | V9.5 | Suno と似たツール。上位プランではステム・MIDI・DAW 形式で書き出せる。 |
| [Udio](https://www.udio.com) | 🎤☁️ | UMG と和解した後、ライセンス済みの「囲い込み型」サービスに移行 | **2025-10 からダウンロード不可**。配信されている曲の制作元である可能性は低い。 |
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
| [ACE-Step 1.5](https://github.com/ace-step/ACE-Step-1.5) | 🎤🇯🇵💻 | MIT | 歌詞は50以上の言語に対応。VRAM 6GB 程度から動く。最長10分。LoRA 学習に対応。Mac・AMD・CUDA で動作。2026-04 に XL(4B)を追加。 |
| [YuE / YuE2](https://github.com/multimodal-art-projection/YuE) | 🎤🇯🇵💻 | Apache 2.0(YuE) | 英語・中国語・**日本語**・韓国語に対応。VRAM を多く使う(24GB 以上)。YuE2 は重みのライセンスが違う可能性があるので、モデルカードで確認すること。 |
| [SongGeneration / LeVo 2](https://github.com/tencent-ailab/SongGeneration) | 🎤💻 | Tencent 独自(非商用のみ) | 音質が高い。VRAM 10GB 以上が目安。 |
| [HeartMuLa](https://github.com/HeartMuLa/heartlib) | 🎤💻 | Apache 2.0 | 2026年の多言語対応の楽曲生成モデル。 |
| [DiffRhythm](https://github.com/ASLP-lab/DiffRhythm) | 🎤💻 | Apache 2.0 | 拡散モデルで1曲を丸ごと高速に生成する。 |
| [SongBloom](https://github.com/tencent-ailab/SongBloom) | 🎤💻 | リポジトリ参照 | 参照用の音声が必要。 |
| [InspireMusic](https://github.com/FunAudioLLM/InspireMusic) | 🎹💻 | リポジトリ参照 | インストのみ。 |
| [MusicGen (AudioCraft)](https://github.com/facebookresearch/audiocraft) | 🎹💻 | コードは MIT、重みは CC BY-NC | テキスト→音楽生成の定番ベースライン。 |

## 4. AIシンガー／歌声合成

音奏羽アリナ、Cyana、MINORI のような「AIシンガー」を作るためのツールです。メロディは自分で作り、歌声だけを合成させる使い方もできます。

| ツール | | メモ |
| --- | --- | --- |
| [Synthesizer V](https://dreamtonics.com/synthesizerv/) | 🎤🇯🇵💻 | Dreamtonics 製。AI 歌声合成で、日本語ボイスが充実している。 |
| [VOCALOID6](https://www.vocaloid.com) | 🎤🇯🇵💻 | ヤマハ製。歌声合成の元祖で、AI ボイスバンクもある。 |
| [ACE Studio](https://acestudio.ai) | 🎤🇯🇵💻 | 権利処理済みのボイスが多い AI 歌声合成。 |
| [NEUTRINO](https://studio-neutrino.com) | 🎤🇯🇵💻 | 無料で使える日本語の AI 歌声合成。 |
| [RVC](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI) | 🎤💻 | オープンソースの声質変換。自分に権利がある声にだけ使うこと。 |
| [Seed-VC](https://github.com/Plachtaa/seed-vc) | 🎤💻 | 事前学習なしで話し声・歌声を変換できる。 |

## 5. 仕上げ・配信

| ツール | 役割 |
| --- | --- |
| [Demucs](https://github.com/facebookresearch/demucs) / [UVR](https://github.com/Anjok07/ultimatevocalremovergui) | パートごとの分離(オープンソース) |
| [Moises](https://moises.ai) | パート分離、コード検出、歌詞の書き起こし |
| [LANDR](https://www.landr.com) | AI マスタリング＋配信 |
| [TuneCore Japan](https://www.tunecore.co.jp) | 配信代行。**de〜ku** がここで「AIミュージッククリエイター」と名乗っている。 |

---

## クラスタ別に合いそうなツール

| クラスタ | 合いそうなツール |
| --- | --- |
| **A. Soft Melodic** | Suno、Lyria 3.5 / Gemini、Mureka。AIシンガー系のプロジェクトは Synthesizer V や ACE Studio。 |
| **B. Hard Edge** | Suno(荒い質感が欲しいなら v6-wild)、ElevenLabs Music。ダンス・EDM 系の下地は Stable Audio。 |
| **C. Wa Spiritual** | Suno(Echo Scroll がクレジットに記載)。アンビエントや儀式系の下地は Stable Audio や AIVA。AI AINU のように、歌は人間で AI は補助という作り方もある。 |
| **和ロック群** | Suno で J-Rock・和楽器系のプロンプトを使う。日本語歌詞をローカルで作るなら ACE-Step や YuE。 |

使っているツールを本人が明かしているアーティストは少数です(README の「AIに関する明示メモ」を参照)。それ以外のこの表の内容は推測で、そのツールで作られたと断定するものではありません。

---

*最終更新: 2026-09-26*
