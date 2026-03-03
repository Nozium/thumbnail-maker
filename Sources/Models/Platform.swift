import Foundation

enum Platform: String, CaseIterable, Identifiable {
    case twitter = "X"
    case notecom = "note"
    case linkedin = "LinkedIn"

    var id: String { rawValue }

    var canvasSize: CGSize {
        switch self {
        case .twitter:  return CGSize(width: 1080, height: 1080)
        case .notecom:  return CGSize(width: 1280, height: 670)
        case .linkedin: return CGSize(width: 1200, height: 627)
        }
    }

    var aspectRatio: CGFloat {
        canvasSize.width / canvasSize.height
    }
}
