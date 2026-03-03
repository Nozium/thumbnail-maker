import SwiftUI

enum ImageRenderService {
    @MainActor
    static func render(project: ThumbnailProject) -> PlatformImage? {
        let canvasSize = project.canvasSize

        let canvasView = ThumbnailCanvasView(project: project)
            .frame(width: canvasSize.width, height: canvasSize.height)

        let renderer = ImageRenderer(content: canvasView)
        renderer.scale = 1.0
        renderer.isOpaque = true
        renderer.proposedSize = ProposedViewSize(canvasSize)

        guard let cgImage = renderer.cgImage else { return nil }

        #if os(macOS)
        return NSImage(cgImage: cgImage, size: canvasSize)
        #else
        return UIImage(cgImage: cgImage)
        #endif
    }
}
