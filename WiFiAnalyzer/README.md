# Wi-Fi Analyzer (iOS)

A SwiftUI iPhone app that analyzes the Wi-Fi network you are connected to.

| Tab | What it does |
| --- | --- |
| **Wi-Fi** | SSID, BSSID, security type, IPv4 address / mask / network / broadcast / router, IPv6 addresses, IPv4/IPv6/DNS support, Low Data Mode |
| **Latency** | Live chart of latency to your router, Cloudflare (1.1.1.1) and Google (8.8.8.8) once per second, with avg / min / max / jitter / loss |
| **Speed** | Ping, download and upload test against `speed.cloudflare.com` (Wi-Fi only, cellular disabled) |
| **Devices** | Scans the local /24 for devices (TCP probes on common ports) and lists Bonjour services (AirPlay, Chromecast, printers, HomeKit…) |

## What iOS does *not* allow

Apple does not give App Store apps access to **signal strength (RSSI), channel, band, noise, or a list of nearby networks** (that requires the `NEHotspotHelper` entitlement, which Apple grants only to specific hotspot operators). ICMP ping is also unavailable, so latency is measured with a TCP handshake. This app therefore uses router latency, jitter and packet loss as a proxy for link quality.

## Build & run

Requirements: macOS with Xcode 15+ and [XcodeGen](https://github.com/yonaskolb/XcodeGen).

```sh
brew install xcodegen
cd WiFiAnalyzer
xcodegen generate
open WiFiAnalyzer.xcodeproj
```

1. In **Signing & Capabilities**, choose your team and change the bundle ID (`com.example.wifianalyzer`) to something unique.
2. Keep the **Access Wi-Fi Information** capability (already in the entitlements). Depending on your account type it may require a paid Apple Developer Program membership.
3. Run on a **real iPhone** (the simulator has no Wi-Fi).
4. Allow **precise** location (needed for SSID/BSSID) and **Local Network** access (needed for the device scan).

---

## 日本語

接続中の Wi-Fi を分析する iPhone 用 SwiftUI アプリです。

- **Wi-Fi タブ**: SSID・BSSID・セキュリティ方式・IP アドレス / サブネット / ルーター・IPv6 など
- **Latency タブ**: ルーター / Cloudflare / Google への遅延を毎秒グラフ化（平均・最小・最大・ジッター・ロス率）
- **Speed タブ**: Cloudflare のサーバーで Ping・ダウンロード・アップロード速度を測定（モバイル通信は使用しない）
- **Devices タブ**: 同じ /24 ネットワーク内の機器スキャンと Bonjour サービス一覧

**iOS の制限**: App Store アプリは電波強度 (RSSI)・チャンネル・周波数帯・周辺ネットワーク一覧を取得できません。ICMP ping も使えないため TCP ハンドシェイクで遅延を測ります。代わりにルーターへの遅延・ジッター・ロス率で電波品質を推定します。

**ビルド**: Mac で `brew install xcodegen` → `cd WiFiAnalyzer && xcodegen generate` → Xcode で開き、Team とバンドル ID を設定して実機で実行。位置情報は「正確な位置情報」を許可、ローカルネットワークへのアクセスも許可してください。
