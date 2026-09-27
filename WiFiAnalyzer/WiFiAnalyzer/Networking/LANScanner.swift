import Foundation
import Network

struct LANDevice: Identifiable, Sendable {
    var id: UInt32 { ip.value }
    let ip: IPv4
    let openPorts: [UInt16]
    let latencyMs: Double?
}

struct BonjourService: Identifiable, Hashable {
    var id: String { "\(type)|\(name)" }
    let name: String
    let type: String

    var kind: String { LANProbe.bonjourLabels[type] ?? type }
}

/// Stateless probing helpers (kept off the main actor).
enum LANProbe {
    static let ports: [UInt16] = [80, 443, 22, 445, 548, 7000, 8009, 62078]

    static let portNames: [UInt16: String] = [
        80: "HTTP", 443: "HTTPS", 22: "SSH", 445: "SMB", 548: "AFP",
        7000: "AirPlay", 8009: "Chromecast", 62078: "Apple device",
    ]

    static let bonjourLabels: [String: String] = [
        "_http._tcp": "Web interface",
        "_airplay._tcp": "AirPlay",
        "_raop._tcp": "AirPlay audio",
        "_googlecast._tcp": "Chromecast",
        "_ipp._tcp": "Printer (IPP)",
        "_printer._tcp": "Printer (LPD)",
        "_smb._tcp": "File sharing (SMB)",
        "_afpovertcp._tcp": "File sharing (AFP)",
        "_ssh._tcp": "SSH",
        "_hap._tcp": "HomeKit accessory",
        "_companion-link._tcp": "Apple device",
        "_spotify-connect._tcp": "Spotify Connect",
    ]

    /// Probes all known ports of one host in parallel. Any answer (open or reset) means the host is alive.
    static func probe(_ ip: IPv4) async -> LANDevice? {
        let host = ip.description
        let results = await withTaskGroup(of: (UInt16, ProbeResult).self) { group in
            for port in ports {
                group.addTask { (port, await TCPProbe.connect(host: host, port: port, timeout: 0.8)) }
            }
            var all: [(UInt16, ProbeResult)] = []
            for await result in group { all.append(result) }
            return all
        }
        let rtts = results.compactMap { $0.1.rttMs }
        guard !rtts.isEmpty else { return nil }
        let open = results.filter { $0.1.isOpen }.map(\.0).sorted()
        return LANDevice(ip: ip, openPorts: open, latencyMs: rtts.min())
    }
}

/// Discovers devices on the local /24 with TCP probes and lists Bonjour services.
@MainActor
final class LANScanner: ObservableObject {
    @Published private(set) var devices: [LANDevice] = []
    @Published private(set) var services: [BonjourService] = []
    @Published private(set) var isScanning = false
    @Published private(set) var progress: Double = 0
    @Published private(set) var scannedRange: String?
    @Published private(set) var errorMessage: String?

    /// Hosts probed at once. Each host opens one socket per port, so keep this
    /// well below the per-process file descriptor limit (256).
    private let concurrency = 16

    private var scanTask: Task<Void, Never>?
    private var browsers: [NWBrowser] = []
    private var bonjourStopTask: Task<Void, Never>?

    func scan(subnet: IPv4Subnet?) {
        guard !isScanning else { return }
        guard let subnet else {
            errorMessage = "Connect to a Wi-Fi network first."
            return
        }
        let hosts = subnet.scanTargets()
        guard let first = hosts.first, let last = hosts.last else {
            errorMessage = "This network has no hosts to scan."
            return
        }

        errorMessage = nil
        devices = []
        progress = 0
        scannedRange = "\(first) – \(last)"
        isScanning = true
        startBonjour()

        scanTask = Task { [weak self] in
            await self?.run(hosts)
            guard !Task.isCancelled else { return }
            self?.finish()
        }
    }

    func cancel() {
        scanTask?.cancel()
        scanTask = nil
        finish()
    }

    private func finish() {
        isScanning = false
        // Leave Bonjour browsing a little longer so slow responders still show up.
        bonjourStopTask?.cancel()
        bonjourStopTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(5))
            guard !Task.isCancelled else { return }
            self?.stopBonjour()
        }
    }

    private func run(_ hosts: [IPv4]) async {
        let total = Double(hosts.count)
        var done = 0.0
        await withTaskGroup(of: LANDevice?.self) { group in
            var iterator = hosts.makeIterator()
            for _ in 0..<concurrency {
                guard let host = iterator.next() else { break }
                group.addTask { await LANProbe.probe(host) }
            }
            while let result = await group.next() {
                if Task.isCancelled {
                    group.cancelAll()
                    break
                }
                done += 1
                progress = done / total
                if let device = result {
                    devices.append(device)
                    devices.sort { $0.ip < $1.ip }
                }
                if let host = iterator.next() {
                    group.addTask { await LANProbe.probe(host) }
                }
            }
        }
    }

    // MARK: Bonjour

    private func startBonjour() {
        bonjourStopTask?.cancel()
        stopBonjour()
        services = []
        for type in LANProbe.bonjourLabels.keys.sorted() {
            let browser = NWBrowser(for: .bonjour(type: type, domain: nil), using: .tcp)
            browser.browseResultsChangedHandler = { [weak self] results, _ in
                let found: [BonjourService] = results.compactMap { result in
                    guard case .service(let name, _, _, _) = result.endpoint else { return nil }
                    return BonjourService(name: name, type: type)
                }
                Task { @MainActor in self?.merge(found, type: type) }
            }
            browser.start(queue: .main)
            browsers.append(browser)
        }
    }

    private func stopBonjour() {
        browsers.forEach { $0.cancel() }
        browsers = []
    }

    private func merge(_ found: [BonjourService], type: String) {
        services.removeAll { $0.type == type }
        services.append(contentsOf: found)
        services.sort { ($0.name.localizedLowercase, $0.type) < ($1.name.localizedLowercase, $1.type) }
    }
}
