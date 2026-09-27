import Charts
import SwiftUI

struct LatencyView: View {
    @EnvironmentObject private var latency: LatencyMonitor
    @EnvironmentObject private var network: NetworkInfoStore

    private var points: [LatencySample] {
        latency.samples.filter { $0.ms != nil }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    if latency.samples.isEmpty {
                        ContentUnavailableView(
                            "No measurements yet",
                            systemImage: "waveform.path.ecg",
                            description: Text("Tap Start to ping your router and the internet once per second.")
                        )
                        .frame(height: 220)
                    } else {
                        Chart(points) { sample in
                            LineMark(
                                x: .value("Time", sample.time),
                                y: .value("Latency (ms)", sample.ms ?? 0)
                            )
                            .foregroundStyle(by: .value("Target", sample.target))
                            .interpolationMethod(.monotone)
                        }
                        .chartYAxisLabel("ms")
                        .chartXAxis(.hidden)
                        .frame(height: 220)
                        .padding(.vertical, 8)
                    }
                }

                Section("Statistics (last \(latency.window) s)") {
                    ForEach(latency.targets) { target in
                        StatsRow(target: target, stats: latency.stats(for: target))
                    }
                }

                Section {
                    Text("Latency is measured with a TCP handshake (iOS apps cannot send ICMP pings). Router latency on a healthy Wi-Fi link is typically under 10 ms; spikes, jitter and loss to the router point to Wi-Fi problems, while issues only on internet targets point to your ISP.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Latency")
            .toolbar {
                Button(latency.isRunning ? "Stop" : "Start") {
                    if latency.isRunning {
                        latency.stop()
                    } else {
                        latency.start(gateway: network.gateway)
                    }
                }
                .bold()
            }
        }
    }
}

private struct StatsRow: View {
    let target: LatencyTarget
    let stats: LatencyStats

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(target.name).font(.headline)
                Text(target.host).font(.caption.monospaced()).foregroundStyle(.secondary)
                Spacer()
                Text("\(format(stats.last)) ms")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(color(for: stats.last))
            }
            HStack {
                stat("avg", stats.average)
                stat("min", stats.minimum)
                stat("max", stats.maximum)
                stat("jitter", stats.jitter)
                VStack {
                    Text("loss").font(.caption2).foregroundStyle(.secondary)
                    Text("\(format(stats.lossPercent, digits: 0))%")
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(stats.lossPercent > 0 ? .red : .primary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 4)
    }

    private func stat(_ title: String, _ value: Double?) -> some View {
        VStack {
            Text(title).font(.caption2).foregroundStyle(.secondary)
            Text(format(value)).font(.caption.monospacedDigit())
        }
        .frame(maxWidth: .infinity)
    }

    private func color(for ms: Double?) -> Color {
        guard let ms else { return .red }
        switch ms {
        case ..<30: return .green
        case ..<100: return .orange
        default: return .red
        }
    }
}
