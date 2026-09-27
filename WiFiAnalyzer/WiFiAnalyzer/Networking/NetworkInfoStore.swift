import CoreLocation
import Foundation
import Network
import NetworkExtension

/// Everything iOS lets a third-party app know about the current Wi-Fi connection.
@MainActor
final class NetworkInfoStore: NSObject, ObservableObject {
    // Wi-Fi (needs location permission + the Access Wi-Fi Information entitlement)
    @Published private(set) var ssid: String?
    @Published private(set) var bssid: String?
    @Published private(set) var security: String?

    // Path
    @Published private(set) var isOnWiFi = false
    @Published private(set) var isSatisfied = false
    @Published private(set) var gateway: String?
    @Published private(set) var isExpensive = false
    @Published private(set) var isConstrained = false
    @Published private(set) var supportsIPv4 = false
    @Published private(set) var supportsIPv6 = false
    @Published private(set) var supportsDNS = false

    // Addresses
    @Published private(set) var subnet: IPv4Subnet?
    @Published private(set) var ipv6Addresses: [String] = []

    // Permissions
    @Published private(set) var locationStatus: CLAuthorizationStatus = .notDetermined
    @Published private(set) var hasPreciseLocation = false

    @Published private(set) var lastUpdated: Date?

    private let monitor = NWPathMonitor()
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationStatus = locationManager.authorizationStatus
        hasPreciseLocation = locationManager.accuracyAuthorization == .fullAccuracy

        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in self?.apply(path) }
        }
        monitor.start(queue: DispatchQueue(label: "WiFiAnalyzer.path"))
    }

    deinit {
        monitor.cancel()
    }

    var canReadWiFiName: Bool {
        (locationStatus == .authorizedWhenInUse || locationStatus == .authorizedAlways) && hasPreciseLocation
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func refresh() async {
        subnet = NetworkInterfaces.wifiSubnet()
        ipv6Addresses = NetworkInterfaces.wifiIPv6Addresses()

        if let network = await NEHotspotNetwork.fetchCurrent() {
            ssid = network.ssid
            bssid = network.bssid
            security = Self.describe(network.securityType)
        } else {
            ssid = nil
            bssid = nil
            security = nil
        }
        lastUpdated = Date()
    }

    private func apply(_ path: Network.NWPath) {
        isSatisfied = path.status == .satisfied
        isOnWiFi = path.usesInterfaceType(.wifi)
        isExpensive = path.isExpensive
        isConstrained = path.isConstrained
        supportsIPv4 = path.supportsIPv4
        supportsIPv6 = path.supportsIPv6
        supportsDNS = path.supportsDNS

        let gateways = path.gateways.compactMap(Self.hostString)
        gateway = gateways.first { IPv4($0) != nil } ?? gateways.first

        Task { await refresh() }
    }

    private static func hostString(_ endpoint: Network.NWEndpoint) -> String? {
        guard case .hostPort(let host, _) = endpoint else { return nil }
        switch host {
        case .ipv4(let address): return "\(address)"
        case .ipv6(let address): return "\(address)"
        case .name(let name, _): return name
        @unknown default: return nil
        }
    }

    private static func describe(_ type: NEHotspotNetworkSecurityType) -> String {
        switch type {
        case .open: return "Open (no password)"
        case .personal: return "WPA/WPA2/WPA3 Personal"
        case .enterprise: return "WPA/WPA2/WPA3 Enterprise"
        case .unknown: return "Unknown"
        default: return "WEP"
        }
    }
}

extension NetworkInfoStore: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        let precise = manager.accuracyAuthorization == .fullAccuracy
        Task { @MainActor in
            self.locationStatus = status
            self.hasPreciseLocation = precise
            await self.refresh()
        }
    }
}
