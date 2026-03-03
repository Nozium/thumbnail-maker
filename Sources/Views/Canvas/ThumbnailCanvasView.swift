import SwiftUI

struct ThumbnailCanvasView: View {
    var project: ThumbnailProject

    // iPhone display corner radius ratio: 55pt / 390pt width ≈ 0.141
    private let iphoneCornerRadiusRatio: CGFloat = 0.141

    // Canvas corner radius ratio (subtle rounding for the output image)
    private let canvasCornerRadiusRatio: CGFloat = 0.02

    var body: some View {
        GeometryReader { geo in
            let scale = geo.size.width / project.canvasSize.width
            let canvasRadius = geo.size.width * canvasCornerRadiusRatio

            ZStack {
                backgroundLayer(scale: scale)
                mediaLayer(scale: scale)

                if project.templateStyle == .fullBleed {
                    Rectangle()
                        .fill(project.overlayColor.opacity(project.overlayOpacity))
                }

                textLayer(scale: scale)
            }
            .clipShape(RoundedRectangle(cornerRadius: canvasRadius, style: .continuous))
        }
        .aspectRatio(project.platform.aspectRatio, contentMode: .fit)
    }

    // MARK: - Background

    @ViewBuilder
    private func backgroundLayer(scale: CGFloat) -> some View {
        switch project.templateStyle {
        case .centeredScreenshot:
            centeredBackground
        case .fullBleed:
            fullBleedBackground(scale: scale)
        }
    }

    @ViewBuilder
    private func fullBleedBackground(scale: CGFloat) -> some View {
        #if os(macOS)
        if let videoURL = project.sourceVideoURL {
            VideoPlayerView(url: videoURL)
        } else if let image = project.sourceImage {
            Image(platformImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Color.gray.opacity(0.3)
        }
        #else
        if let image = project.sourceImage {
            Image(platformImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Color.gray.opacity(0.3)
        }
        #endif
    }

    @ViewBuilder
    private var centeredBackground: some View {
        switch project.backgroundConfig.backgroundType {
        case .solid:
            Rectangle().fill(project.backgroundConfig.solidColor)
        case .gradient:
            LinearGradient(
                colors: project.backgroundConfig.gradientPreset.colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .custom:
            let angle = Angle.degrees(project.backgroundConfig.gradientAngle)
            LinearGradient(
                colors: [
                    project.backgroundConfig.customGradientStart,
                    project.backgroundConfig.customGradientEnd
                ],
                startPoint: unitPoint(for: angle),
                endPoint: unitPoint(for: angle + .degrees(180))
            )
        }
    }

    // MARK: - Media (Image or Video)

    @ViewBuilder
    private func mediaLayer(scale: CGFloat) -> some View {
        if project.templateStyle == .centeredScreenshot {
            centeredMediaLayer(scale: scale)
        }
        // fullBleed: media is rendered as background (above), not as a separate layer
    }

    @ViewBuilder
    private func centeredMediaLayer(scale: CGFloat) -> some View {
        let screenshotWidth = project.canvasSize.width * project.screenshotScale * scale
        let screenshotHeight = project.canvasSize.height * project.screenshotScale * scale
        let cornerRadius = screenshotWidth * iphoneCornerRadiusRatio

        #if os(macOS)
        if let videoURL = project.sourceVideoURL {
            VideoPlayerView(url: videoURL)
                .frame(width: screenshotWidth, height: screenshotHeight)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .shadow(color: .black.opacity(0.3), radius: 12 * scale, y: 6 * scale)
                .offset(
                    x: project.screenshotHorizontalOffset * scale,
                    y: project.screenshotVerticalOffset * scale
                )
        } else if let image = project.sourceImage {
            imageView(image: image, width: screenshotWidth, height: screenshotHeight,
                      cornerRadius: cornerRadius, scale: scale)
        }
        #else
        if let image = project.sourceImage {
            imageView(image: image, width: screenshotWidth, height: screenshotHeight,
                      cornerRadius: cornerRadius, scale: scale)
        }
        #endif
    }

    @ViewBuilder
    private func imageView(image: PlatformImage, width: CGFloat, height: CGFloat,
                           cornerRadius: CGFloat, scale: CGFloat) -> some View {
        Image(platformImage: image)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: width, maxHeight: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.3), radius: 12 * scale, y: 6 * scale)
            .offset(
                x: project.screenshotHorizontalOffset * scale,
                y: project.screenshotVerticalOffset * scale
            )
    }

    // MARK: - Text (9-position grid)

    @ViewBuilder
    private func textLayer(scale: CGFloat) -> some View {
        let config = project.textConfig
        let pos = config.titlePosition
        let pad = 20 * scale

        VStack(spacing: 0) {
            if pos.verticalZone == .center || pos.verticalZone == .bottom {
                Spacer()
            }

            HStack(spacing: 0) {
                if pos.horizontalZone == .center || pos.horizontalZone == .trailing {
                    Spacer()
                }

                VStack(alignment: pos.horizontalAlignment, spacing: 8 * scale) {
                    if !config.title.isEmpty {
                        Text(config.title)
                            .font(.system(size: config.titleFontSize * scale, weight: .bold))
                            .foregroundStyle(config.titleColor)
                            .multilineTextAlignment(pos.textAlignment)
                            .shadow(color: .black.opacity(0.5), radius: 2 * scale)
                    }

                    if config.showSubtitle && !config.subtitle.isEmpty {
                        Text(config.subtitle)
                            .font(.system(size: config.subtitleFontSize * scale, weight: .medium))
                            .foregroundStyle(config.subtitleColor)
                            .multilineTextAlignment(pos.textAlignment)
                            .shadow(color: .black.opacity(0.3), radius: 1 * scale)
                    }
                }

                if pos.horizontalZone == .leading || pos.horizontalZone == .center {
                    Spacer()
                }
            }

            if pos.verticalZone == .top || pos.verticalZone == .center {
                Spacer()
            }
        }
        .padding(pad)
    }

    // MARK: - Helpers

    private func unitPoint(for angle: Angle) -> UnitPoint {
        let radians = angle.radians
        let x = 0.5 + 0.5 * cos(radians)
        let y = 0.5 + 0.5 * sin(radians)
        return UnitPoint(x: x, y: y)
    }
}
