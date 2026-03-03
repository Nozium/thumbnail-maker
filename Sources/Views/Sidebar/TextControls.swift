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

            VStack(alignment: .leading, spacing: 4) {
                Text("Position")
                TextPositionGrid(selection: $config.titlePosition)
            }
        }
    }
}

// MARK: - 3x3 Position Grid

struct TextPositionGrid: View {
    @Binding var selection: TextPosition

    private let rows: [[TextPosition]] = [
        [.topLeft, .topCenter, .topRight],
        [.centerLeft, .center, .centerRight],
        [.bottomLeft, .bottomCenter, .bottomRight]
    ]

    var body: some View {
        Grid(horizontalSpacing: 4, verticalSpacing: 4) {
            ForEach(rows, id: \.first) { row in
                GridRow {
                    ForEach(row) { pos in
                        Button {
                            selection = pos
                        } label: {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(selection == pos ? Color.accentColor : Color.secondary.opacity(0.2))
                                .frame(width: 28, height: 20)
                                .overlay {
                                    positionIcon(pos)
                                        .foregroundStyle(selection == pos ? .white : .secondary)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func positionIcon(_ pos: TextPosition) -> some View {
        let h = pos.horizontalZone
        let v = pos.verticalZone

        GeometryReader { geo in
            let w: CGFloat = 10
            let barH: CGFloat = 2
            let x: CGFloat = {
                switch h {
                case .leading: return 3
                case .center: return (geo.size.width - w) / 2
                case .trailing: return geo.size.width - w - 3
                }
            }()
            let y: CGFloat = {
                switch v {
                case .top: return 4
                case .center: return (geo.size.height - barH) / 2
                case .bottom: return geo.size.height - barH - 4
                }
            }()

            RoundedRectangle(cornerRadius: 1)
                .frame(width: w, height: barH)
                .offset(x: x, y: y)
        }
    }
}
