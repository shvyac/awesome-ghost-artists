import Foundation

struct LatencyTarget: Identifiable, Hashable, Sendable {
    var id: String { name }
    let name: String
    let host: String
    let port: UInt16
}

struct LatencySample: Identifiable, Sendable {
    let id = UUID()
    let target: String
    let time: Date
    let ms: Double?
}

struct LatencyStats {
    var count = 0
    var last: Double?
    var average: Double?
    var minimum: Double?
    var maximum: Double?
    /// Mean absolute difference between consecutive successful samples.
    var jitter: Double?
    var lossPercent: Double = 0
}

/// Continuously measures TCP handshake latency to the router and to the internet.
@MainActor
final class LatencyMonitor: ObservableObject {
    @Published private(set) var samples: [LatencySample] = []
    @Published private(set) var targets: [LatencyTarget] = LatencyMonitor.internetTargets
    @Published private(set) var isRunning = false

    /// How many samples per target are kept (one per second).
    let window = 60

    static let internetTargets = [
        LatencyTarget(name: "Cloudflare", host: "1.1.1.1", port: 443),
        LatencyTarget(name: "Google", host: "8.8.8.8", port: 443),
    ]

    private var task: Task<Void, Never>?

    func start(gateway: String?) {
        guard !isRunning else { return }
        var list = Self.internetTargets
        if let gateway {
            // Port 53 (DNS) is usually open on home routers; a reset works just as well.
            list.insert(LatencyTarget(name: "Router", host: gateway, port: 53), at: 0)
        }
        targets = list
        samples = []
        isRunning = true

        task = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                let round = await Self.measure(self.targets)
                guard !Task.isCancelled else { return }
                self.append(round)
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
        isRunning = false
    }

    func stats(for target: LatencyTarget) -> LatencyStats {
        let series = samples.filter { $0.target == target.name }
        let values = series.compactMap(\.ms)
        var stats = LatencyStats()
        stats.count = series.count
        stats.last = series.last?.ms
        guard !series.isEmpty else { return stats }
        stats.lossPercent = Double(series.count - values.count) / Double(series.count) * 100
        guard !values.isEmpty else { return stats }
        stats.average = values.reduce(0, +) / Double(values.count)
        stats.minimum = values.min()
        stats.maximum = values.max()
        if values.count > 1 {
            let diffs = zip(values, values.dropFirst()).map { abs($1 - $0) }
            stats.jitter = diffs.reduce(0, +) / Double(diffs.count)
        }
        return stats
    }

    private func append(_ round: [LatencySample]) {
        samples.append(contentsOf: round)
        let limit = window * max(targets.count, 1)
        if samples.count > limit {
            samples.removeFirst(samples.count - limit)
        }
    }

    private nonisolated static func measure(_ targets: [LatencyTarget]) async -> [LatencySample] {
        await withTaskGroup(of: LatencySample.self) { group in
            for target in targets {
                group.addTask {
                    let result = await TCPProbe.connect(host: target.host, port: target.port, timeout: 1.5)
                    return LatencySample(target: target.name, time: Date(), ms: result.rttMs)
                }
            }
            var round: [LatencySample] = []
            for await sample in group { round.append(sample) }
            return round
        }
    }
}
