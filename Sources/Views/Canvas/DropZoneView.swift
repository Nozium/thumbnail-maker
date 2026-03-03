import SwiftUI

struct DropZoneView: View {
    var isTargeted: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .strokeBorder(
                style: StrokeStyle(lineWidth: 2, dash: [10])
            )
            .foregroundStyle(isTargeted ? .blue : .secondary)
            .overlay {
                VStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    #if os(macOS)
                    Text("Paste screenshot (Cmd+V)\nor drag & drop image here")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    #else
                    Text("Tap to paste or select image")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    #endif
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isTargeted ? Color.blue.opacity(0.05) : Color.clear)
            )
    }
}
