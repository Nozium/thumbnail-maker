import Foundation

enum TemplateStyle: String, CaseIterable, Identifiable {
    case centeredScreenshot = "Center"
    case fullBleed = "Full"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .centeredScreenshot: return "Screenshot + Background"
        case .fullBleed: return "Full + Overlay"
        }
    }
}
