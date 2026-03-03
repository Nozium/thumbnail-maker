import SwiftUI

@Observable
final class ThumbnailProject {
    var platform: Platform = .twitter
    var templateStyle: TemplateStyle = .centeredScreenshot
    var sourceImage: PlatformImage? = nil
    var textConfig = TextConfiguration()
    var backgroundConfig = BackgroundConfiguration()

    // Style B (fullBleed) overlay
    var overlayOpacity: Double = 0.4
    var overlayColor: Color = .black

    // Style A (centeredScreenshot) screenshot sizing
    var screenshotScale: CGFloat = 0.65
    var screenshotHorizontalOffset: CGFloat = 0
    var screenshotVerticalOffset: CGFloat = 0

    // Video / GIF
    var sourceVideoURL: URL? = nil
    var gifFPS: Double = 10
    var gifMaxDuration: Double = 5

    var canvasSize: CGSize { platform.canvasSize }
    var hasSource: Bool { sourceImage != nil || sourceVideoURL != nil }
    var isVideo: Bool { sourceVideoURL != nil }
}
