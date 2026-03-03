import SwiftUI

struct TextControls: View {
    @Bindable var config: TextConfiguration

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Text").font(.headline)

            TextField("Title", text: $config.title, prompt: Text("Enter title..."))
                .textFieldStyle(.roundedBorder)

            Toggle("Subtitle", isOn: $config.showSubtitle)
            if config.showSubtitle {
                TextField("Subtitle", text: $config.subtitle, prompt: Text("Enter subtitle..."))
                    .textFieldStyle(.roundedBorder)
            }

            HStack {
                Text("Size")
                Slider(value: $config.titleFontSize, in: 20...80, step: 2)
                Text("\(Int(config.titleFontSize))")
                    .monospacedDigit()
                    .frame(width: 30)
            }

            ColorPicker("Color", selection: $config.titleColor)

            Picker("Position", selection: $config.titlePosition) {
                ForEach(TextPosition.allCases) { pos in
                    Text(pos.rawValue).tag(pos)
                }
            }
        }
    }
}
