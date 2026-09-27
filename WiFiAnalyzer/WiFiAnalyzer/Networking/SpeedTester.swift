import Foundation

/// Download / upload throughput test against Cloudflare's public speed test endpoints.
/// Each direction runs for a fixed time and cellular is disabled, so the result
/// reflects the Wi-Fi link (and your internet connection behind it).
@MainActor
final class SpeedTester: NSObject, ObservableObject {
    enum Phase: Equatable {
        case idle, latency, download, upload, finished
        case failed(String)

        var title: String {
            switch self {
            case .idle: return "Ready"
            case .latency: return "Measuring latency…"
            case .download: return "Download"
            case .upload: return "Upload"
            case .finished: return "Done"
            case .failed(let message): return message
            }
        }
    }

    struct Result: Identifiable {
        let id = UUID()
        let date: Date
        let pingMs: Double?
        let downloadMbps: Double?
        let uploadMbps: Double?
    }

    @Published private(set) var phase: Phase = .idle
    @Published private(set) var pingMs: Double?
    @Published private(set) var downloadMbps: Double?
    @Published private(set) var uploadMbps: Double?
    @Published private(set) var liveMbps: Double = 0
    @Published private(set) var progress: Double = 0
    @Published private(set) var history: [Result] = []

    var isRunning: Bool {
        switch phase {
        case .latency, .download, .upload: return true
        default: return false
        }
    }

    private let host = "speed.cloudflare.com"
    private let phaseDuration: TimeInterval = 8
    private let uploadBytes = 40_000_000

    private var runTask: Task<Void, Never>?
    private var session: URLSession?
    private var continuation: CheckedContinuation<Void, Never>?
    private var countingDownload = false
    private var transferred: Int64 = 0
    private var phaseStart = Date()
    private var firstByteAt: Date?
    private var lastByteAt: Date?
    private var lastUIUpdate = Date.distantPast

    func start() {
        guard !isRunning else { return }
        runTask = Task { await run() }
    }

    func cancel() {
        runTask?.cancel()
        runTask = nil
        session?.invalidateAndCancel()
        session = nil
        liveMbps = 0
        phase = .idle
    }

    private func run() async {
        pingMs = nil
        downloadMbps = nil
        uploadMbps = nil
        liveMbps = 0
        progress = 0

        // 1. Latency
        phase = .latency
        var pings: [Double] = []
        for _ in 0..<5 {
            if let ms = await TCPProbe.connect(host: host, port: 443, timeout: 2).rttMs {
                pings.append(ms)
            }
            if Task.isCancelled { return }
        }
        guard !pings.isEmpty else {
            phase = .failed("Could not reach \(host) over Wi-Fi.")
            return
        }
        pingMs = pings.sorted()[pings.count / 2]

        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = false
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.timeoutIntervalForRequest = 15
        let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
        self.session = session
        defer { session.finishTasksAndInvalidate() }

        // 2. Download
        phase = .download
        let downloadURL = URL(string: "https://\(host)/__down?bytes=\(1_000_000_000)")!
        countingDownload = true
        let down = await measure(session.dataTask(with: downloadURL))
        countingDownload = false
        if Task.isCancelled { return }
        downloadMbps = down

        // 3. Upload
        phase = .upload
        var request = URLRequest(url: URL(string: "https://\(host)/__up")!)
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        let up = await measure(session.uploadTask(with: request, from: Data(count: uploadBytes)))
        if Task.isCancelled { return }
        uploadMbps = up

        liveMbps = 0
        progress = 1
        if down == nil && up == nil {
            phase = .failed("The speed test server did not respond.")
        } else {
            phase = .finished
            history.insert(Result(date: Date(), pingMs: pingMs, downloadMbps: down, uploadMbps: up), at: 0)
        }
    }

    /// Runs `task` for at most `phaseDuration` seconds and returns the throughput in Mbps.
    private func measure(_ task: URLSessionTask) async -> Double? {
        transferred = 0
        firstByteAt = nil
        lastByteAt = nil
        liveMbps = 0
        progress = 0
        phaseStart = Date()

        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            self.continuation = continuation
            task.resume()
            DispatchQueue.main.asyncAfter(deadline: .now() + phaseDuration) { [weak task] in
                task?.cancel()
            }
        }

        guard let first = firstByteAt, let last = lastByteAt, transferred > 0 else { return nil }
        let seconds = max(last.timeIntervalSince(first), 0.1)
        return Double(transferred) * 8 / seconds / 1_000_000
    }

    fileprivate func record(bytes: Int64) {
        let now = Date()
        if firstByteAt == nil { firstByteAt = now }
        lastByteAt = now
        transferred += bytes

        // Throttle UI updates to ~10 per second.
        guard now.timeIntervalSince(lastUIUpdate) > 0.1, let first = firstByteAt else { return }
        lastUIUpdate = now
        let seconds = now.timeIntervalSince(first)
        if seconds > 0.2 {
            liveMbps = Double(transferred) * 8 / seconds / 1_000_000
        }
        progress = min(1, now.timeIntervalSince(phaseStart) / phaseDuration)
    }

    fileprivate func taskCompleted() {
        continuation?.resume()
        continuation = nil
    }
}

// The session's delegate queue is `.main`, so these callbacks run on the main actor.
extension SpeedTester: URLSessionDataDelegate {
    nonisolated func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let count = Int64(data.count)
        MainActor.assumeIsolated {
            if self.countingDownload { self.record(bytes: count) }
        }
    }

    nonisolated func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64,
                                totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        MainActor.assumeIsolated { self.record(bytes: bytesSent) }
    }

    nonisolated func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        MainActor.assumeIsolated { self.taskCompleted() }
    }
}
