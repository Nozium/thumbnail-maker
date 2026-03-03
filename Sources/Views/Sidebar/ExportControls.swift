import SwiftUI

struct ExportControls: View {
    var project: ThumbnailProject
    @State private var showCopySuccess = false
    #if os(iOS)
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?
    #endif

    var body: some View {
        VStack(spacing: 12) {
            Button(action: copyToClipboard) {
                HStack {
                    Image(systemName: showCopySuccess ? "checkmark.circle.fill" : "doc.on.clipboard")
                    Text(showCopySuccess ? "Copied!" : "Copy to Clipboard")
                }
                .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .disabled(!project.hasSourceImage)

            #if os(macOS)
            Button(action: exportAsPNG) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Export as PNG")
                }
                .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
            .buttonStyle(.bordered)
            .disabled(!project.hasSourceImage)
            #else
            Button(action: shareAction) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
                .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
            .buttonStyle(.bordered)
            .disabled(!project.hasSourceImage)
            .sheet(isPresented: $showShareSheet) {
                if let image = shareImage {
                    ShareSheet(items: [image])
                }
            }
            #endif
        }
    }

    private func copyToClipboard() {
        guard let image = ImageRenderService.render(project: project) else { return }
        ClipboardService.shared.writeImage(image)
        showCopySuccess = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showCopySuccess = false
        }
    }

    #if os(macOS)
    private func exportAsPNG() {
        guard let image = ImageRenderService.render(project: project) else { return }
        let name = "thumbnail-\(project.platform.rawValue.lowercased())"
        ExportService.savePNG(image: image, suggestedName: name)
    }
    #else
    private func shareAction() {
        guard let image = ImageRenderService.render(project: project) else { return }
        shareImage = image
        showShareSheet = true
    }
    #endif
}

// MARK: - iOS Share Sheet

#if os(iOS)
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#endif
