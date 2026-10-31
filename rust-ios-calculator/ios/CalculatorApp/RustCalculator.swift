import Foundation
import CalcCore

/// Rust の Calculator を包む Swift ラッパー
final class RustCalculator: ObservableObject {
    private let ptr: OpaquePointer
    @Published private(set) var display = "0"

    init() { ptr = calc_new() }
    deinit { calc_free(ptr) }

    func press(_ key: Character) {
        guard let scalar = key.unicodeScalars.first else { return }
        calc_press(ptr, scalar.value)
        let cstr = calc_display(ptr)!
        display = String(cString: cstr)
        calc_string_free(cstr)
    }
}
