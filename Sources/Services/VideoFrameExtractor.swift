import AVFoundation
import CoreGraphics

enum VideoFrameExtractor {
    struct ExtractionResult {
        let frames: [CGImage]
        let frameDuration: Double
    }

    static func extractFrames(
        from url: URL,
        fps: Double,
        maxDuration: Double
    ) async throws -> ExtractionResult {
        let asset = AVAsset(url: url)
        let duration = try await asset.load(.duration)
        let totalSeconds = min(CMTimeGetSeconds(duration), maxDuration)
        let frameCount = Int(totalSeconds * fps)
        guard frameCount > 0 else { return ExtractionResult(frames: [], frameDuration: 1.0 / fps) }

        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = .zero

        // Set max size to avoid huge frames from 4K video
        generator.maximumSize = CGSize(width: 1280, height: 1280)

        var frames: [CGImage] = []
        let interval = 1.0 / fps

        for i in 0..<frameCount {
            let time = CMTime(seconds: Double(i) * interval, preferredTimescale: 600)
            do {
                let (image, _) = try await generator.image(at: time)
                frames.append(image)
            } catch {
                // Skip frames that fail to extract
                continue
            }
        }

        return ExtractionResult(frames: frames, frameDuration: interval)
    }

    /// Extract just the first frame for preview
    static func extractFirstFrame(from url: URL) async -> CGImage? {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 1280, height: 1280)

        let time = CMTime(seconds: 0, preferredTimescale: 600)
        return try? await generator.image(at: time).image
    }
}
