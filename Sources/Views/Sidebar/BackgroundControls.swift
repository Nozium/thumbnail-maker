import SwiftUI

struct BackgroundControls: View {
    @Bindable var config: BackgroundConfiguration

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Background").font(.headline)

            Picker("Type", selection: $config.backgroundType) {
                ForEach(BackgroundType.allCases) { t in
                    Text(t.rawValue).tag(t)
                }
            }
            .pickerStyle(.segmented)

            switch config.backgroundType {
            case .solid:
                ColorPicker("Color", selection: $config.solidColor)
            case .gradient:
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 8) {
                    ForEach(GradientPreset.allCases) { preset in
                        GradientPresetView(
                            preset: preset,
                            isSelected: config.gradientPreset == preset
                        ) {
                            config.gradientPreset = preset
                        }
                    }
                }
            case .custom:
                ColorPicker("Start", selection: $config.customGradientStart)
                ColorPicker("End", selection: $config.customGradientEnd)
                HStack {
                    Text("Angle")
                    Slider(value: $config.gradientAngle, in: 0...360, step: 15)
                    Text("\(Int(config.gradientAngle))")
                        .monospacedDigit()
                        .frame(width: 30)
                }
            }
        }
    }
}
