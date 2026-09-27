import SwiftUI

struct DevicesView: View {
    @EnvironmentObject private var scanner: LANScanner
    @EnvironmentObject private var network: NetworkInfoStore

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        scanner.isScanning ? scanner.cancel() : scanner.scan(subnet: network.subnet)
                    } label: {
                        Label(scanner.isScanning ? "Stop Scan" : "Scan Network",
                              systemImage: scanner.isScanning ? "stop.circle" : "dot.radiowaves.left.and.right")
                    }
                    if scanner.isScanning {
                        ProgressView(value: scanner.progress) {
                            Text("Scanning \(scanner.scannedRange ?? "")")
                                .font(.caption.monospaced())
                        }
                    } else if let range = scanner.scannedRange {
                        InfoRow(label: "Scanned", value: range, monospaced: true)
                    }
                    if let error = scanner.errorMessage {
                        Text(error).foregroundStyle(.red)
                    }
                }

                Section("Hosts (\(scanner.devices.count))") {
                    if scanner.devices.isEmpty {
                        Text(scanner.isScanning ? "Looking for devices…" : "Tap Scan Network to find devices.")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(scanner.devices) { device in
                        DeviceRow(device: device,
                                  isSelf: device.ip == network.subnet?.address,
                                  isRouter: device.ip.description == network.gateway)
                    }
                }

                if !scanner.services.isEmpty {
                    Section("Bonjour services (\(scanner.services.count))") {
                        ForEach(scanner.services) { service in
                            VStack(alignment: .leading) {
                                Text(service.name)
                                Text(service.kind).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section {
                    Text("Devices are found by probing common TCP ports; devices with a firewall that ignores all of them won't appear. iOS will ask for Local Network permission the first time you scan.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Devices")
        }
    }
}

private struct DeviceRow: View {
    let device: LANDevice
    let isSelf: Bool
    let isRouter: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.accentColor)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(device.ip.description).font(.body.monospaced())
                    if isSelf { tag("This iPhone") }
                    if isRouter { tag("Router") }
                }
                if !device.openPorts.isEmpty {
                    Text(device.openPorts.map { LANProbe.portNames[$0] ?? "\($0)" }.joined(separator: " · "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if let ms = device.latencyMs {
                Text("\(format(ms, digits: 0)) ms")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var icon: String {
        let ports = Set(device.openPorts)
        if isRouter { return "wifi.router" }
        if isSelf || ports.contains(62078) { return "iphone" }
        if ports.contains(8009) { return "tv" }
        if ports.contains(7000) { return "airplayvideo" }
        if ports.contains(445) || ports.contains(548) { return "externaldrive.connected.to.line.below" }
        if ports.contains(80) || ports.contains(443) { return "globe" }
        return "desktopcomputer"
    }

    private func tag(_ text: String) -> some View {
        Text(text)
            .font(.caption2.bold())
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.accentColor.opacity(0.15), in: Capsule())
    }
}
