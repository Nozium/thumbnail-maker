import SwiftUI

struct PlatformPicker: View {
    @Binding var platform: Platform

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Platform").font(.headline)
            Picker("Platform", selection: $platform) {
                ForEach(Platform.allCases) { p in
                    Text(p.rawValue).tag(p)
                }
            }
            .pickerStyle(.segmented)
            Text("\(Int(platform.canvasSize.width)) x \(Int(platform.canvasSize.height))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
