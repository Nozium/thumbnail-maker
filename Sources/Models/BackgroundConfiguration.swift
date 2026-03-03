import SwiftUI

enum BackgroundType: String, CaseIterable, Identifiable {
    case solid = "Solid"
    case gradient = "Gradient"
    case custom = "Custom"

    var id: String { rawValue }
}

enum GradientPreset: String, CaseIterable, Identifiable {
    case bluePurple = "Blue-Purple"
    case orangePink = "Orange-Pink"
    case greenTeal = "Green-Teal"
    case darkSlate = "Dark Slate"
    case sunset = "Sunset"
    case ocean = "Ocean"

    var id: String { rawValue }

    var colors: [Color] {
        switch self {
        case .bluePurple: return [.blue, .purple]
        case .orangePink: return [.orange, .pink]
        case .greenTeal: return [.green, .teal]
        case .darkSlate:
            return [
                Color(hue: 0.6, saturation: 0.3, brightness: 0.2),
                Color(hue: 0.7, saturation: 0.3, brightness: 0.35)
            ]
        case .sunset: return [Color.red.opacity(0.8), .orange]
        case .ocean:
            return [
                Color(hue: 0.55, saturation: 0.8, brightness: 0.3),
                Color(hue: 0.5, saturation: 0.6, brightness: 0.6)
            ]
        }
    }
}

@Observable
final class BackgroundConfiguration {
    var backgroundType: BackgroundType = .gradient
    var solidColor: Color = .blue
    var gradientPreset: GradientPreset = .bluePurple
    var customGradientStart: Color = .blue
    var customGradientEnd: Color = .purple
    var gradientAngle: Double = 135
}
