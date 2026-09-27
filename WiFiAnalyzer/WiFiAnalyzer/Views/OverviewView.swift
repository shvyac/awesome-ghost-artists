import SwiftUI
import UIKit

struct OverviewView: View {
    @EnvironmentObject private var network: NetworkInfoStore
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            List {
                header

                if !network.canReadWiFiName {
                    permissionSection
                }

                Section("Wi-Fi") {
                    InfoRow(label: "Network (SSID)", value: network.ssid)
                    InfoRow(label: "Access point (BSSID)", value: network.bssid, monospaced: true)
                    InfoRow(label: "Security", value: network.security)
                }

                Section("IPv4") {
                    InfoRow(label: "IP address", value: network.subnet?.address.description, monospaced: true)
                    InfoRow(label: "Subnet mask", value: network.subnet?.mask.description, monospaced: true)
                    InfoRow(label: "Network", value: network.subnet?.cidr, monospaced: true)
                    InfoRow(label: "Broadcast", value: network.subnet?.broadcast.description, monospaced: true)
                    InfoRow(label: "Router", value: network.gateway, monospaced: true)
                    InfoRow(label: "Usable hosts", value: network.subnet.map { "\($0.usableHosts)" })
                }

                Section("IPv6") {
                    if network.ipv6Addresses.isEmpty {
                        Text("No IPv6 address").foregroundStyle(.secondary)
                    } else {
                        ForEach(network.ipv6Addresses, id: \.self) { address in
                            Text(address)
                                .font(.callout.monospaced())
                                .textSelection(.enabled)
                        }
                    }
                }

                Section("Connection") {
                    InfoRow(label: "Internet", value: network.isSatisfied ? "Available" : "Unavailable")
                    InfoRow(label: "IPv4 / IPv6", value: "\(yesNo(network.supportsIPv4)) / \(yesNo(network.supportsIPv6))")
                    InfoRow(label: "DNS", value: yesNo(network.supportsDNS))
                    InfoRow(label: "Low Data Mode", value: network.isConstrained ? "On" : "Off")
                    InfoRow(label: "Expensive (hotspot)", value: yesNo(network.isExpensive))
                }

                Section {
                    Text("iOS does not allow App Store apps to read signal strength (RSSI), channel, band, or to list nearby networks. Use the Latency and Speed tabs to judge link quality — high jitter or packet loss to the router usually means weak signal or interference.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("About signal strength")
                }
            }
            .navigationTitle("Wi-Fi")
            .refreshable { await network.refresh() }
            .toolbar {
                Button {
                    Task { await network.refresh() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }

    private var header: some View {
        Section {
            HStack(spacing: 16) {
                Image(systemName: network.isOnWiFi ? "wifi" : "wifi.slash")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(network.isOnWiFi ? Color.accentColor : .secondary)
                    .frame(width: 56, height: 56)
                    .background(.fill.tertiary, in: Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text(network.isOnWiFi ? (network.ssid ?? "Connected") : "Not on Wi-Fi")
                        .font(.title2.bold())
                    if let ip = network.subnet?.address {
                        Text(ip.description).font(.subheadline.monospaced()).foregroundStyle(.secondary)
                    }
                    if let updated = network.lastUpdated {
                        Text("Updated \(updated.formatted(date: .omitted, time: .standard))")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    private var permissionSection: some View {
        Section {
            Text("iOS only shares the Wi-Fi name (SSID) and access point (BSSID) with apps that have **precise** location access. Your location is not stored or sent anywhere.")
                .font(.footnote)
            if network.locationStatus == .notDetermined {
                Button("Allow Location Access") { network.requestLocationPermission() }
            } else {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) }
                }
            }
        } header: {
            Text("Permission needed")
        }
    }

    private func yesNo(_ value: Bool) -> String { value ? "Yes" : "No" }
}
