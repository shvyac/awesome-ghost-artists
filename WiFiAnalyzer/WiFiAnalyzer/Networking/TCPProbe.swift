import Foundation
import Network

enum ProbeResult: Sendable {
    /// The port accepted the connection.
    case open(ms: Double)
    /// The host answered with a TCP reset: it is alive, the port is closed.
    case refused(ms: Double)
    /// No answer before the timeout.
    case unreachable

    var rttMs: Double? {
        switch self {
        case .open(let ms), .refused(let ms): return ms
        case .unreachable: return nil
        }
    }

    var isOpen: Bool {
        if case .open = self { return true }
        return false
    }
}

/// Measures round-trip time with a TCP handshake over Wi-Fi.
/// iOS does not let regular apps send ICMP pings, so a SYN → SYN/ACK (or RST)
/// exchange is the closest equivalent.
enum TCPProbe {
    static func connect(host: String, port: UInt16, timeout: TimeInterval = 1.5) async -> ProbeResult {
        guard let nwPort = NWEndpoint.Port(rawValue: port) else { return .unreachable }

        let tcp = NWProtocolTCP.Options()
        tcp.connectionTimeout = max(1, Int(timeout.rounded(.up)))
        tcp.noDelay = true
        let parameters = NWParameters(tls: nil, tcp: tcp)
        parameters.requiredInterfaceType = .wifi

        let connection = NWConnection(host: NWEndpoint.Host(host), port: nwPort, using: parameters)
        let queue = DispatchQueue(label: "WiFiAnalyzer.probe")

        return await withCheckedContinuation { continuation in
            var finished = false
            let start = DispatchTime.now().uptimeNanoseconds

            func elapsedMs() -> Double {
                Double(DispatchTime.now().uptimeNanoseconds - start) / 1_000_000
            }

            // Always called on `queue`, so `finished` needs no extra locking.
            func finish(_ result: ProbeResult) {
                guard !finished else { return }
                finished = true
                connection.stateUpdateHandler = nil
                connection.cancel()
                continuation.resume(returning: result)
            }

            connection.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    finish(.open(ms: elapsedMs()))
                case .waiting(let error), .failed(let error):
                    if case .posix(let code) = error, code == .ECONNREFUSED {
                        finish(.refused(ms: elapsedMs()))
                    } else {
                        finish(.unreachable)
                    }
                case .cancelled:
                    finish(.unreachable)
                default:
                    break
                }
            }
            connection.start(queue: queue)
            queue.asyncAfter(deadline: .now() + timeout) { finish(.unreachable) }
        }
    }
}
