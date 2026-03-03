import SwiftUI

struct SidebarView: View {
    @Bindable var project: ThumbnailProject

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            PlatformPicker(platform: $project.platform)
            Divider()
            TemplatePicker(style: $project.templateStyle)
            Divider()
            TextControls(config: project.textConfig)
            Divider()

            if project.templateStyle == .centeredScreenshot {
                BackgroundControls(config: project.backgroundConfig)
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    Text("Screenshot").font(.headline)
                    HStack {
                        Text("Scale")
                        Slider(value: $project.screenshotScale, in: 0.3...0.95)
                    }
                    HStack {
                        Text("X")
                        Slider(value: $project.screenshotHorizontalOffset, in: -200...200)
                    }
                    HStack {
                        Text("Y")
                        Slider(value: $project.screenshotVerticalOffset, in: -200...200)
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Overlay").font(.headline)
                    HStack {
                        Text("Opacity")
                        Slider(value: $project.overlayOpacity, in: 0.0...0.8)
                    }
                    ColorPicker("Color", selection: $project.overlayColor)
                }
            }

            if project.isVideo {
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    Text("GIF Settings").font(.headline)
                    HStack {
                        Text("FPS")
                        Slider(value: $project.gifFPS, in: 5...15, step: 1)
                        Text("\(Int(project.gifFPS))")
                            .monospacedDigit()
                            .frame(width: 24)
                    }
                    HStack {
                        Text("Duration")
                        Slider(value: $project.gifMaxDuration, in: 1...10, step: 0.5)
                        Text("\(project.gifMaxDuration, specifier: "%.1f")s")
                            .monospacedDigit()
                            .frame(width: 36)
                    }
                }
            }

            Divider()
            ExportControls(project: project)

            Spacer()
        }
    }
}
