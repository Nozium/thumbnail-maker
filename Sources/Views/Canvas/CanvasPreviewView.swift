import SwiftUI
import UniformTypeIdentifiers

struct CanvasPreviewView: View {
    @Bindable var project: ThumbnailProject
    @State private var isDropTargeted = false

    var body: some View {
        GeometryReader { geo in
            let previewSize = fittedSize(
                canvasSize: project.canvasSize,
                availableSize: geo.size,
                padding: 40
            )

            VStack {
                Spacer()
                HStack {
                    Spacer()

                    if project.hasSource {
                        ZStack(alignment: .topTrailing) {
                            ThumbnailCanvasView(project: project)
                                .frame(width: previewSize.width, height: previewSize.height)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .shadow(radius: 8)

                            if project.isVideo {
                                Label("Video", systemImage: "film")
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Capsule())
                                    .padding(8)
                            }
                        }
                    } else {
                        DropZoneView(isTargeted: isDropTargeted)
                            .frame(width: previewSize.width, height: previewSize.height)
                    }

                    Spacer()
                }
                Spacer()
            }
        }
        #if os(macOS)
        .onDrop(of: [.image, .movie], isTargeted: $isDropTargeted) { providers in
            handleDrop(providers)
        }
        .background(Color(nsColor: .windowBackgroundColor))
        #else
        .background(Color(uiColor: .systemGroupedBackground))
        #endif
    }

    private func fittedSize(canvasSize: CGSize, availableSize: CGSize, padding: CGFloat) -> CGSize {
        let available = CGSize(
            width: max(availableSize.width - padding * 2, 100),
            height: max(availableSize.height - padding * 2, 100)
        )
        let scaleX = available.width / canvasSize.width
        let scaleY = available.height / canvasSize.height
        let scale = min(scaleX, scaleY, 1.0)
        return CGSize(
            width: canvasSize.width * scale,
            height: canvasSize.height * scale
        )
    }

    #if os(macOS)
    private func handleDrop(_ providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }

        // Try video first
        if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
            provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, _ in
                guard let url else { return }
                // Copy to temp location (drop URLs are temporary)
                let tempURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString)
                    .appendingPathExtension(url.pathExtension)
                try? FileManager.default.copyItem(at: url, to: tempURL)

                Task {
                    let firstFrame = await VideoFrameExtractor.extractFirstFrame(from: tempURL)
                    await MainActor.run {
                        project.sourceVideoURL = tempURL
                        if let firstFrame {
                            project.sourceImage = NSImage(cgImage: firstFrame, size: .zero)
                        }
                    }
                }
            }
            return true
        }

        // Fallback: image
        provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
            if let data, let image = NSImage(data: data) {
                DispatchQueue.main.async {
                    project.sourceImage = image
                    project.sourceVideoURL = nil
                }
            }
        }
        return true
    }
    #endif
}
