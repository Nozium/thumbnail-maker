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

    var canvasSize: CGSize { platform.canvasSize }
    var hasSourceImage: Bool { sourceImage != nil }
}
