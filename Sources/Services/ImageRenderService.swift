import SwiftUI

enum ImageRenderService {
    @MainActor
    static func render(project: ThumbnailProject) -> PlatformImage? {
        guard let cgImage = renderCGImage(project: project) else { return nil }

        #if os(macOS)
        return NSImage(cgImage: cgImage, size: project.canvasSize)
        #else
        return UIImage(cgImage: cgImage)
        #endif
    }

    @MainActor
    static func renderCGImage(project: ThumbnailProject) -> CGImage? {
        let canvasSize = project.canvasSize

        let canvasView = ThumbnailCanvasView(project: project)
            .frame(width: canvasSize.width, height: canvasSize.height)

        let renderer = ImageRenderer(content: canvasView)
        renderer.scale = 1.0
        renderer.isOpaque = true
        renderer.proposedSize = ProposedViewSize(canvasSize)

        return renderer.cgImage
    }
}
