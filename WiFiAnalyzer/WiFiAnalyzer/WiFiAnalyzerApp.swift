import SwiftUI

@main
struct WiFiAnalyzerApp: App {
    @StateObject private var network = NetworkInfoStore()
    @StateObject private var latency = LatencyMonitor()
    @StateObject private var speed = SpeedTester()
    @StateObject private var scanner = LANScanner()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
                .environmentObject(latency)
                .environmentObject(speed)
                .environmentObject(scanner)
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            OverviewView()
                .tabItem { Label("Wi-Fi", systemImage: "wifi") }
            LatencyView()
                .tabItem { Label("Latency", systemImage: "waveform.path.ecg") }
            SpeedTestView()
                .tabItem { Label("Speed", systemImage: "speedometer") }
            DevicesView()
                .tabItem { Label("Devices", systemImage: "network") }
        }
    }
}
