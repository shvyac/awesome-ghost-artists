# Rust iOS Calculator

Rust（計算ロジック）+ SwiftUI（画面）で作るシンプルな iOS 電卓。

```
calc-core/        Rust ライブラリ（staticlib + C FFI）
  src/lib.rs      電卓ロジック & FFI 関数
  include/        C ヘッダ + module.modulemap（Swift から import CalcCore）
ios/CalculatorApp Swift ソース（App / View / Rust ラッパー）
build-ios.sh      xcframework ビルドスクリプト
```

## 手順（Mac で）

1. Rust をインストール: `curl https://sh.rustup.rs -sSf | sh`
2. `./build-ios.sh` → `CalcCore.xcframework` が生成される
3. Xcode で新規プロジェクト（iOS › App, Interface: SwiftUI, 名前 `CalculatorApp`）
4. 自動生成された Swift ファイルを削除し、`ios/CalculatorApp/*.swift` を追加
5. `CalcCore.xcframework` をプロジェクトにドラッグ
   （Target › General › Frameworks に **Do Not Embed** で追加）
6. シミュレータ or 実機で ▶ Run

## テスト

```
cd calc-core && cargo test
```
