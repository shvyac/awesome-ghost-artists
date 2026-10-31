import SwiftUI

struct ContentView: View {
    @StateObject private var calc = RustCalculator()

    // (表示ラベル, Rust に送るキー)
    private let rows: [[(String, Character)]] = [
        [("C", "C"), ("±", "N"), ("%", "%"), ("÷", "/")],
        [("7", "7"), ("8", "8"), ("9", "9"), ("×", "*")],
        [("4", "4"), ("5", "5"), ("6", "6"), ("−", "-")],
        [("1", "1"), ("2", "2"), ("3", "3"), ("+", "+")],
        [("0", "0"), (".", "."), ("=", "=")],
    ]

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text(calc.display)
                .font(.system(size: 64, weight: .light, design: .rounded))
                .lineLimit(1).minimumScaleFactor(0.4)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)
            ForEach(rows.indices, id: \.self) { r in
                HStack(spacing: 12) {
                    ForEach(rows[r], id: \.0) { label, key in
                        Button { calc.press(key) } label: {
                            Text(label)
                                .font(.title).bold()
                                .frame(maxWidth: label == "0" ? .infinity : 72, minHeight: 72)
                                .background(color(for: key))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }

    private func color(for key: Character) -> Color {
        switch key {
        case "+", "-", "*", "/", "=": return .orange
        case "C", "N", "%": return .gray
        default: return Color(white: 0.2)
        }
    }
}
