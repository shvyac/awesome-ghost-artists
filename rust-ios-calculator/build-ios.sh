#!/bin/bash
# macOS + Xcode で実行。CalcCore.xcframework を生成する
set -euo pipefail
cd "$(dirname "$0")/calc-core"

rustup target add aarch64-apple-ios aarch64-apple-ios-sim x86_64-apple-ios
for t in aarch64-apple-ios aarch64-apple-ios-sim x86_64-apple-ios; do
  cargo build --release --target "$t"
done

mkdir -p target/sim
lipo -create \
  target/aarch64-apple-ios-sim/release/libcalc_core.a \
  target/x86_64-apple-ios/release/libcalc_core.a \
  -output target/sim/libcalc_core.a

rm -rf ../CalcCore.xcframework
xcodebuild -create-xcframework \
  -library target/aarch64-apple-ios/release/libcalc_core.a -headers include \
  -library target/sim/libcalc_core.a -headers include \
  -output ../CalcCore.xcframework
echo "✅ CalcCore.xcframework を作成しました"
