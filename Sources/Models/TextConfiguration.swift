import SwiftUI

enum TextPosition: String, CaseIterable, Identifiable {
    case top = "Top"
    case center = "Center"
    case bottom = "Bottom"

    var id: String { rawValue }
}

@Observable
final class TextConfiguration {
    var title: String = ""
    var subtitle: String = ""
    var titleFontSize: CGFloat = 48
    var subtitleFontSize: CGFloat = 28
    var titleColor: Color = .white
    var subtitleColor: Color = .white.opacity(0.85)
    var titlePosition: TextPosition = .bottom
    var showSubtitle: Bool = false
}
