import SwiftUI

struct InfoRow: View {
    let label: String
    let value: String?
    var monospaced = false

    var body: some View {
        LabeledContent(label) {
            Text(value ?? "—")
                .font(monospaced ? .body.monospaced() : .body)
                .foregroundStyle(value == nil ? .tertiary : .secondary)
                .multilineTextAlignment(.trailing)
                .textSelection(.enabled)
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: Double?
    let unit: String
    var digits = 1

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(format(value, digits: digits))
                .font(.title2.bold().monospacedDigit())
            Text(unit)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.fill.tertiary, in: RoundedRectangle(cornerRadius: 12))
    }
}

func format(_ value: Double?, digits: Int = 1) -> String {
    guard let value else { return "—" }
    return value.formatted(.number.precision(.fractionLength(digits)))
}
