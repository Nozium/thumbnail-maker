import SwiftUI

enum TextPosition: String, CaseIterable, Identifiable {
    case topLeft = "TL"
    case topCenter = "TC"
    case topRight = "TR"
    case centerLeft = "CL"
    case center = "C"
    case centerRight = "CR"
    case bottomLeft = "BL"
    case bottomCenter = "BC"
    case bottomRight = "BR"

    var id: String { rawValue }

    var horizontalAlignment: HorizontalAlignment {
        switch self {
        case .topLeft, .centerLeft, .bottomLeft: return .leading
        case .topCenter, .center, .bottomCenter: return .center
        case .topRight, .centerRight, .bottomRight: return .trailing
        }
    }

    var textAlignment: TextAlignment {
        switch self {
        case .topLeft, .centerLeft, .bottomLeft: return .leading
        case .topCenter, .center, .bottomCenter: return .center
        case .topRight, .centerRight, .bottomRight: return .trailing
        }
    }

    var verticalZone: VerticalZone {
        switch self {
        case .topLeft, .topCenter, .topRight: return .top
        case .centerLeft, .center, .centerRight: return .center
        case .bottomLeft, .bottomCenter, .bottomRight: return .bottom
        }
    }

    var horizontalZone: HorizontalZone {
        switch self {
        case .topLeft, .centerLeft, .bottomLeft: return .leading
        case .topCenter, .center, .bottomCenter: return .center
        case .topRight, .centerRight, .bottomRight: return .trailing
        }
    }

    enum VerticalZone { case top, center, bottom }
    enum HorizontalZone { case leading, center, trailing }
}

@Observable
final class TextConfiguration {
    var title: String = ""
    var subtitle: String = ""
    var titleFontSize: CGFloat = 48
    var subtitleFontSize: CGFloat = 28
    var titleColor: Color = .white
    var subtitleColor: Color = .white.opacity(0.85)
    var titlePosition: TextPosition = .bottomCenter
    var showSubtitle: Bool = false
}
