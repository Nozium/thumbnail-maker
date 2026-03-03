import SwiftUI

struct ThumbnailCanvasView: View {
    var project: ThumbnailProject

    // iPhone display corner radius ratio: 55pt / 390pt width ≈ 0.141
    private let iphoneCornerRadiusRatio: CGFloat = 0.141

    var body: some View {
        GeometryReader { geo in
            let scale = geo.size.width / project.canvasSize.width

            ZStack {
                backgroundLayer(scale: scale)
                screenshotLayer(scale: scale)

                if project.templateStyle == .fullBleed {
                    Rectangle()
                        .fill(project.overlayColor.opacity(project.overlayOpacity))
                }

                textLayer(scale: scale)
            }
        }
        .aspectRatio(project.platform.aspectRatio, contentMode: .fit)
        .clipped()
    }

    // MARK: - Background

    @ViewBuilder
    private func backgroundLayer(scale: CGFloat) -> some View {
        switch project.templateStyle {
        case .centeredScreenshot:
            centeredBackground
        case .fullBleed:
            if let image = project.sourceImage {
                Image(platformImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.gray.opacity(0.3)
            }
        }
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

    // MARK: - Screenshot

    @ViewBuilder
    private func screenshotLayer(scale: CGFloat) -> some View {
        if project.templateStyle == .centeredScreenshot, let image = project.sourceImage {
            let screenshotWidth = project.canvasSize.width * project.screenshotScale * scale
            let screenshotHeight = project.canvasSize.height * project.screenshotScale * scale
            let cornerRadius = screenshotWidth * iphoneCornerRadiusRatio

            Image(platformImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: screenshotWidth, maxHeight: screenshotHeight)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .shadow(color: .black.opacity(0.3), radius: 12 * scale, y: 6 * scale)
                .offset(
                    x: project.screenshotHorizontalOffset * scale,
                    y: project.screenshotVerticalOffset * scale
                )
        }
    }

    // MARK: - Text

    @ViewBuilder
    private func textLayer(scale: CGFloat) -> some View {
        let config = project.textConfig

        VStack(spacing: 8 * scale) {
            if config.titlePosition == .top {
                Spacer().frame(height: 20 * scale)
            }
            if config.titlePosition == .bottom {
                Spacer()
            }

            if !config.title.isEmpty {
                Text(config.title)
                    .font(.system(size: config.titleFontSize * scale, weight: .bold))
                    .foregroundStyle(config.titleColor)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.5), radius: 2 * scale)
            }

            if config.showSubtitle && !config.subtitle.isEmpty {
                Text(config.subtitle)
                    .font(.system(size: config.subtitleFontSize * scale, weight: .medium))
                    .foregroundStyle(config.subtitleColor)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.3), radius: 1 * scale)
            }

            if config.titlePosition == .top {
                Spacer()
            }
            if config.titlePosition == .bottom {
                Spacer().frame(height: 20 * scale)
            }
        }
        .padding(20 * scale)
    }

    // MARK: - Helpers

    private func unitPoint(for angle: Angle) -> UnitPoint {
        let radians = angle.radians
        let x = 0.5 + 0.5 * cos(radians)
        let y = 0.5 + 0.5 * sin(radians)
        return UnitPoint(x: x, y: y)
    }
}
