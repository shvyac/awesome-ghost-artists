import Foundation

/// An IPv4 address stored in host byte order so it can be used for subnet math.
struct IPv4: Hashable, Comparable, CustomStringConvertible, Sendable {
    let value: UInt32

    init(_ value: UInt32) {
        self.value = value
    }

    init?(_ string: String) {
        var addr = in_addr()
        guard inet_pton(AF_INET, string, &addr) == 1 else { return nil }
        value = UInt32(bigEndian: addr.s_addr)
    }

    var description: String {
        "\(value >> 24 & 0xFF).\(value >> 16 & 0xFF).\(value >> 8 & 0xFF).\(value & 0xFF)"
    }

    static func < (lhs: IPv4, rhs: IPv4) -> Bool {
        lhs.value < rhs.value
    }
}

/// The IPv4 configuration of an interface (address + netmask).
struct IPv4Subnet: Hashable, Sendable {
    let address: IPv4
    let mask: IPv4

    var prefixLength: Int { mask.value.nonzeroBitCount }
    var network: IPv4 { IPv4(address.value & mask.value) }
    var broadcast: IPv4 { IPv4(network.value | ~mask.value) }
    var cidr: String { "\(network)/\(prefixLength)" }

    /// Number of usable host addresses in the subnet.
    var usableHosts: Int {
        let size = UInt64(~mask.value) + 1
        return size > 2 ? Int(size - 2) : 0
    }

    /// Addresses to probe during a LAN scan. Subnets larger than /24 are
    /// narrowed to the /24 that contains this device to keep scans quick.
    func scanTargets() -> [IPv4] {
        let effectiveMask: UInt32 = prefixLength >= 24 ? mask.value : 0xFFFF_FF00
        let net = address.value & effectiveMask
        let bcast = net | ~effectiveMask
        guard bcast > net + 1 else { return [] }
        return (net + 1 ..< bcast).map(IPv4.init)
    }
}
