import Foundation

struct InterfaceAddress: Hashable, Sendable {
    enum Family: Sendable { case ipv4, ipv6 }

    let interface: String
    let family: Family
    let address: String
    let netmask: String?
}

enum NetworkInterfaces {
    /// On iPhone the Wi-Fi interface is always `en0`.
    static let wifiInterface = "en0"

    /// All IPv4/IPv6 addresses of interfaces that are up (loopback excluded).
    static func addresses() -> [InterfaceAddress] {
        var list: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&list) == 0, let first = list else { return [] }
        defer { freeifaddrs(list) }

        var result: [InterfaceAddress] = []
        for pointer in sequence(first: first, next: { $0.pointee.ifa_next }) {
            let ifa = pointer.pointee
            let flags = Int32(ifa.ifa_flags)
            guard let sa = ifa.ifa_addr,
                  flags & IFF_UP != 0,
                  flags & IFF_LOOPBACK == 0 else { continue }

            let family: InterfaceAddress.Family
            switch Int32(sa.pointee.sa_family) {
            case AF_INET: family = .ipv4
            case AF_INET6: family = .ipv6
            default: continue
            }
            guard let address = numericHost(sa) else { continue }
            result.append(InterfaceAddress(
                interface: String(cString: ifa.ifa_name),
                family: family,
                address: address,
                netmask: ifa.ifa_netmask.flatMap(numericHost)
            ))
        }
        return result
    }

    static func wifiSubnet() -> IPv4Subnet? {
        addresses()
            .first { $0.interface == wifiInterface && $0.family == .ipv4 }
            .flatMap { entry in
                guard let address = IPv4(entry.address),
                      let mask = entry.netmask.flatMap(IPv4.init) else { return nil }
                return IPv4Subnet(address: address, mask: mask)
            }
    }

    static func wifiIPv6Addresses() -> [String] {
        addresses()
            .filter { $0.interface == wifiInterface && $0.family == .ipv6 }
            .map(\.address)
    }

    private static func numericHost(_ sa: UnsafeMutablePointer<sockaddr>) -> String? {
        var host = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        let status = getnameinfo(sa, socklen_t(sa.pointee.sa_len),
                                 &host, socklen_t(host.count),
                                 nil, 0, NI_NUMERICHOST)
        guard status == 0 else { return nil }
        return String(cString: host)
    }
}
