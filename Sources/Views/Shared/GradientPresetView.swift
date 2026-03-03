import SwiftUI

struct GradientPresetView: View {
    let preset: GradientPreset
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            LinearGradient(
                colors: preset.colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(width: 56, height: 36)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isSelected ? Color.accentColor : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .help(preset.rawValue)
    }
}
