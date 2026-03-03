#if os(macOS)
import AppKit
import ImageIO
import UniformTypeIdentifiers

enum GIFExportService {
    struct Progress {
        let current: Int
        let total: Int
    }

    @MainActor
    static func exportGIF(
        project: ThumbnailProject,
        onProgress: @escaping (Progress) -> Void
    ) async {
        guard let videoURL = project.sourceVideoURL else { return }

        // 1. Extract frames from video
        let originalImage = project.sourceImage
        guard let result = try? await VideoFrameExtractor.extractFrames(
            from: videoURL,
            fps: project.gifFPS,
            maxDuration: project.gifMaxDuration
        ), !result.frames.isEmpty else {
            project.sourceImage = originalImage
            return
        }

        // 2. Render each frame through the canvas
        var renderedFrames: [CGImage] = []
        let total = result.frames.count

        for (i, frame) in result.frames.enumerated() {
            onProgress(Progress(current: i + 1, total: total))

            // Set frame as source image and render
            project.sourceImage = NSImage(cgImage: frame, size: .zero)

            // Small delay to let SwiftUI update
            try? await Task.sleep(nanoseconds: 10_000_000) // 10ms

            if let rendered = ImageRenderService.renderCGImage(project: project) {
                renderedFrames.append(rendered)
            }
        }

        // Restore original preview image
        project.sourceImage = originalImage

        guard !renderedFrames.isEmpty else { return }

        // 3. Save GIF via NSSavePanel
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.gif]
        panel.nameFieldStringValue = "thumbnail-\(project.platform.rawValue.lowercased()).gif"
        panel.canCreateDirectories = true

        guard panel.runModal() == .OK, let url = panel.url else { return }

        writeGIF(frames: renderedFrames, frameDuration: result.frameDuration, to: url)
    }

    private static func writeGIF(frames: [CGImage], frameDuration: Double, to url: URL) {
        guard let destination = CGImageDestinationCreateWithURL(
            url as CFURL,
            UTType.gif.identifier as CFString,
            frames.count,
            nil
        ) else { return }

        // GIF file properties: loop forever
        let gifProperties: [String: Any] = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFLoopCount as String: 0
            ]
        ]
        CGImageDestinationSetProperties(destination, gifProperties as CFDictionary)

        // Add each frame
        let frameProperties: [String: Any] = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFDelayTime as String: frameDuration
            ]
        ]

        for frame in frames {
            CGImageDestinationAddImage(destination, frame, frameProperties as CFDictionary)
        }

        CGImageDestinationFinalize(destination)
    }
}
#endif
