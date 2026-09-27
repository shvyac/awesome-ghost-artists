import SwiftUI

struct SpeedTestView: View {
    @EnvironmentObject private var speed: SpeedTester
    @EnvironmentObject private var network: NetworkInfoStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    SpeedDial(mbps: speed.liveMbps, caption: speed.phase.title)
                        .padding(.top, 8)

                    if speed.isRunning {
                        ProgressView(value: speed.progress)
                            .padding(.horizontal)
                    }

                    HStack(spacing: 12) {
                        MetricCard(title: "Ping", value: speed.pingMs, unit: "ms", digits: 0)
                        MetricCard(title: "Download", value: speed.downloadMbps, unit: "Mbps")
                        MetricCard(title: "Upload", value: speed.uploadMbps, unit: "Mbps")
                    }

                    Button {
                        speed.isRunning ? speed.cancel() : speed.start()
                    } label: {
                        Text(speed.isRunning ? "Stop" : "Start Test")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(!network.isOnWiFi && !speed.isRunning)

                    if !network.isOnWiFi {
                        Label("Connect to Wi-Fi to run a test. Cellular is never used.", systemImage: "wifi.exclamationmark")
                            .font(.footnote)
                            .foregroundStyle(.orange)
                    }

                    if !speed.history.isEmpty {
                        history
                    }

                    Text("Uses Cloudflare's speed test servers (speed.cloudflare.com). Each direction runs for about 8 seconds and transfers up to a few hundred MB on fast connections.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
            .navigationTitle("Speed Test")
        }
    }

    private var history: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("History").font(.headline)
            ForEach(speed.history) { result in
                HStack {
                    Text(result.date.formatted(date: .omitted, time: .shortened))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Label(format(result.downloadMbps), systemImage: "arrow.down")
                    Label(format(result.uploadMbps), systemImage: "arrow.up")
                    Label(format(result.pingMs, digits: 0), systemImage: "timer")
                }
                .font(.callout.monospacedDigit())
                Divider()
            }
        }
    }
}

/// A 270° dial with a logarithmic scale from 0 to 1000 Mbps.
private struct SpeedDial: View {
    let mbps: Double
    let caption: String

    private var fraction: Double {
        min(1, log10(max(mbps, 0) + 1) / log10(1001))
    }

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(.fill.tertiary, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                .rotationEffect(.degrees(135))
            Circle()
                .trim(from: 0, to: 0.75 * fraction)
                .stroke(
                    AngularGradient(colors: [.teal, .blue, .purple], center: .center,
                                    startAngle: .degrees(0), endAngle: .degrees(270)),
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(135))
            VStack(spacing: 2) {
                Text(format(mbps))
                    .font(.system(size: 48, weight: .bold, design: .rounded).monospacedDigit())
                    .contentTransition(.numericText())
                Text("Mbps").font(.subheadline).foregroundStyle(.secondary)
                Text(caption)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 160)
            }
        }
        .frame(width: 240, height: 240)
        .animation(.easeOut(duration: 0.25), value: mbps)
    }
}
