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

            Divider()
            ExportControls(project: project)

            Spacer()
        }
    }
}
